pageextension 50113 "Purchase Order" extends "Purchase Order"
{
    actions
    {
        addfirst(processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import Line';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ImportExcel;
                trigger OnAction()
                begin
                    ReadExcel();
                end;
            }
            action(Export)
            {
                ApplicationArea = All;
                Caption = 'Export Line';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ExportToExcel;
                trigger OnAction()
                begin
                    ExportToExcel();
                end;

            }
        }
    }
    procedure ReadExcel()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[10];
    begin
        UploadIntoStream(UploadMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExelBuffer.SelectSheetsNameStream(Istream);

        end else
            Error(NoFileMsg);
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.OpenBookStream(Istream, SheetName);
        TempExelBuffer.ReadSheet();
        ImportExcelDataHeader();
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExelBuffer.Reset();
        if TempExelBuffer.get(RowNo, ColNo) then
            exit(TempExelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ImportExcelDataHeader()
    var
        ImportBuffer: Record "Purchase Line";
        PurchaseLine: Record "Purchase Line";
        RowNo: Integer;
        ColNo: Integer;
        ItemNo: code[20];
        ItemDescription: Text[250];
        type: Code[20];
        Qty: Decimal;
        QtyToSale: Decimal;
        LineNo: Integer;
        MaxRowNo: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        LocationCode: Code[24];
        BinCode: Code[24];
        UOM: Code[24];
        PostingDate: Date;
        ShortCutDim1: Code[24];
        ShortCutDim2: Code[24];
        Counter: Integer;
        SerailNo: Code[24];
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Importing\No.: #1#####\Record Count: #2#####';
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        ImportBuffer.Reset();
        ImportBuffer.DeleteAll();
        TempExelBuffer.Reset();
        if TempExelBuffer.FindLast() then begin
            MaxRowNo := TempExelBuffer."Row No.";
        end;
        if TempExelBuffer.FindSet() then
            RecordCounted := TempExelBuffer.Count;
        Progress.OPEN(ProgressMsg, ImportBuffer."No.", Counter, RecordCounted);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            //arrange the excel sheet
            Evaluate(ItemNo, GetValueAtCell(RowNo, 1));
            Evaluate(ItemDescription, GetValueAtCell(RowNo, 2));
            Evaluate(LocationCode, GetValueAtCell(RowNo, 3));
            Evaluate(BinCode, GetValueAtCell(RowNo, 4));
            Evaluate(Qty, GetValueAtCell(RowNo, 5));
            Evaluate(UOM, GetValueAtCell(RowNo, 6));

            //arrange the excel sheet
            Counter := Counter + 1;//update dialog

            ImportBuffer.Init();
            ImportBuffer."Document Type" := ImportBuffer."Document Type"::Order;
            ImportBuffer.Type := ImportBuffer.Type::Item;
            ImportBuffer."Line No." := LineNo;
            ImportBuffer."Buy-from Vendor No." := rec."Buy-from Vendor No.";
            ImportBuffer."Document No." := rec."No.";
            ImportBuffer."No." := ItemNo;
            ImportBuffer.Description := ItemDescription;
            ImportBuffer."Location Code" := LocationCode;
            ImportBuffer."Bin Code" := BinCode;
            ImportBuffer.Quantity := Qty;
            ImportBuffer."Unit of Measure Code" := UOM;
            ImportBuffer."Gen. Prod. Posting Group" := GetGenProductPostingGroup(ItemNo);
            ImportBuffer."Posting Group" := GetInventoryPostingGroup(ItemNo);
            ImportBuffer."VAT Prod. Posting Group" := GetVatPostingGroup(ItemNo);
            ImportBuffer."Gen. Bus. Posting Group" := rec."Gen. Bus. Posting Group";
            ImportBuffer."Qty. to Receive" := Qty;
            ImportBuffer."Qty. to Invoice" := Qty;
            ImportBuffer."Outstanding Quantity" := Qty;
            ImportBuffer."Outstanding Qty. (Base)" := Qty;
            ImportBuffer."Qty. to Receive (Base)" := Qty;
            ImportBuffer."Qty. to Invoice (Base)" := Qty;
            ImportBuffer.Insert();
            ImportBuffer.Validate("No.", ImportBuffer."No.");
            ImportBuffer.Validate(Quantity, ImportBuffer.Quantity);
            //ImportBuffer.Validate("Quantity (Base)", Qty);
            Rec.Modify(true);
            Progress.UPDATE(); // Update the field in the dialog. 
        end;
        Progress.CLOSE();
        Message('Total Imported = %1', Counter);
    end;

    procedure GetGenProductPostingGroup(itemno: Code[24]): Code[24]
    var
        item: Record item;
    begin
        item.Reset();
        item.SetRange("No.", itemno);
        if item.Find('-') then
            exit(item."Gen. Prod. Posting Group");
    end;

    procedure GetInventoryPostingGroup(itemno: Code[24]): Code[24]
    var
        item: Record item;
    begin
        item.Reset();
        item.SetRange("No.", itemno);
        if item.Find('-') then
            exit(item."Inventory Posting Group");
    end;

    procedure GetVatPostingGroup(itemno: Code[24]): Code[24]
    var
        item: Record item;
    begin
        item.Reset();
        item.SetRange("No.", itemno);
        if item.Find('-') then
            exit(item."VAT Prod. Posting Group");
    end;
    //Export To excel
    procedure ExportToExcel()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'ImportBuffer';
        ExcelFileName: Label 'Import Template Export_%1__%2';
        TempExcelBufferLine: Record "Excel Buffer" temporary;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Processing : #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin

        //Export Header

        Progress.OPEN(ProgressMsg, TempExelBuffer, Counter, RecordCounted);//progress dialog open
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        //adding header
        TempExcelBuffer.AddColumn('No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location Code', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Bin Code', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Quantity', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        //adding three rows sample
        //#1
        TempExcelBuffer.AddColumn('1000', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Bicycle', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Blue', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('1', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PCS', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet('Purchase', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
        Message('Template Exported.');
    end;

    var
        StyleExpression: Text[50];
        TempExelBuffer: Record "Excel Buffer" temporary;
        LastEntryNo: Integer;
        myInt: Integer;
        ImportMess: Label 'Import Action';
        ExportMess: Label 'Export Action';
        FileName: Text[100];
        SheetName: Text[100];
        UploadMsg: Label 'Please Choose The Excel File';
        NoFileMsg: Label 'No Excel File Found';
        ExcelImportSuccess: Label 'Excel Import Success';
}
