page 50101 "CVH Sale Import Buffer"
{
    Caption = 'CVH Sale Import Buffer';
    PageType = List;
    SourceTable = "CVH Sale Import Buffer";
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Sell-To Customer No."; Rec."Sell-To Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-To Customer No. field.', Comment = '%';
                }
                field("Sell-To Customer Name"; Rec."Sell-To Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-To Customer Name field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Term Code field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project Code field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.', Comment = '%';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsibilty Center field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import';
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
                Caption = 'Export';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ExportToExcel;
                trigger OnAction()
                begin
                    //ExportToExcel();
                end;

            }
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Process;
                trigger OnAction()
                begin
                    // CheckIfSerialExistwhenposted();
                    // CurrPage.Close();
                end;

            }
        }
    }
    procedure ReadExcel()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        NameValueBufferOut: Record "Name/Value Buffer" temporary;
        FromFile: Text[100];
        MaxRow: Integer;
        ColNo: Integer;
        RowNo: Integer;
    begin
        SheetName := '';
        FileName := '';
        if UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream) then begin
            if FromFile <> '' then begin
                FileName := FileMgt.GetFileName(FromFile);
                // SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
                TempExcelBuffer.GetSheetsNameListFromStream(IStream, NameValueBufferOut);
            end else
                Error(NoFileFoundMsg);
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            NameValueBufferOut.Reset();
            if NameValueBufferOut.FindSet() then begin
                repeat
                    Clear(SheetName);
                    SheetName := NameValueBufferOut.Value;
                    TempExcelBuffer.OpenBookStream(IStream, SheetName);
                    TempExcelBuffer.ReadSheet();

                    MaxRow := 0;
                    TempExcelBuffer.Reset();
                    if TempExcelBuffer.FindLast() then
                        MaxRow := TempExcelBuffer."Row No.";

                    ColNo := 0;
                    RowNo := 0;

                    // IF SheetName = SalesInvoiceLineLbl THEN
                    //     ImportExcelDataLines();
                    IF SheetName = SalesInvoiceHeaderLbl THEN
                        ImportExcelDataHeader();
                until NameValueBufferOut.Next() = 0;
            end;
        end else begin
            Message('File is not found');
        end;
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
        ImportBuffer: Record "CVH Sale Import Buffer" temporary;
        SaleLineImportBuffer: Record "Sales Line";
        RowNo: Integer;
        ColNo: Integer;
        Documenttype: Enum "Sales Document Type";
        DocType: Text[20];
        DocumentNo: code[20];
        DocumentDate: date;
        PostingDate: date;
        PaymentTermCode: Code[20];
        ProjectCode: Code[20];
        ResponsibilityCenter: code[20];
        SellToCusNo: Code[20];
        SellToCusName: Text[100];
        MaxRowNo: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        DepartmentCode: Code[20];
        SalePersonCode: code[20];
        Remark: code[20];
        DueDate: Date;
        LocationCode: Code[24];
        Counter: Integer;
        ExternalDocumentNo: Code[24];
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Importing\No.: #1#####\Record Count: #2#####';
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        ImportBuffer.Reset();
        ImportBuffer.DeleteAll();
        TempExelBuffer.Reset();
        if TempExelBuffer.FindLast() then begin
            MaxRowNo := TempExelBuffer."Row No.";
        end;
        if TempExelBuffer.FindSet() then
            RecordCounted := TempExelBuffer.Count;
        Progress.OPEN(ProgressMsg, ImportBuffer."document No.", Counter, RecordCounted);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin
            //arrange the excel sheet
            Evaluate(DocType, GetValueAtCell(RowNo, 1));
            Evaluate(DocumentNo, GetValueAtCell(RowNo, 2));
            Evaluate(SellToCusNo, GetValueAtCell(RowNo, 3));
            Evaluate(SellToCusName, GetValueAtCell(RowNo, 4));
            Evaluate(DocumentDate, GetValueAtCell(RowNo, 5));
            Evaluate(PostingDate, GetValueAtCell(RowNo, 6));
            Evaluate(PaymentTermCode, GetValueAtCell(RowNo, 7));
            Evaluate(DepartmentCode, GetValueAtCell(RowNo, 8));
            Evaluate(ProjectCode, GetValueAtCell(RowNo, 9));
            Evaluate(LocationCode, GetValueAtCell(RowNo, 10));
            Evaluate(DueDate, GetValueAtCell(RowNo, 11));
            Evaluate(ExternalDocumentNo, GetValueAtCell(RowNo, 12));
            Evaluate(ResponsibilityCenter, GetValueAtCell(RowNo, 13));
            //arrange the excel sheet
            Counter := Counter + 1;//update dialog
            ImportBuffer.Init();
            ImportBuffer."Document Type" := DocType;
            ImportBuffer."Document No." := DocumentNo;
            ImportBuffer."Sell-To Customer No." := SellToCusNo;
            ImportBuffer."Sell-To Customer Name" := SellToCusName;
            ImportBuffer."Document Date" := DocumentDate;
            ImportBuffer."Posting Date" := PostingDate;
            ImportBuffer."Payment Term Code" := PaymentTermCode;
            ImportBuffer."Department Code" := DepartmentCode;
            ImportBuffer."Project Code" := ProjectCode;
            ImportBuffer."Location Code" := LocationCode;
            ImportBuffer."Due Date" := DueDate;
            ImportBuffer."External Document No." := ExternalDocumentNo;
            ImportBuffer."Responsibility Center" := ResponsibilityCenter;
            ImportBuffer.Insert();
            ImportBuffer.Modify(true);
            Rec.Reset();
            Rec.Init();
            Rec := ImportBuffer;
            Rec.Modify(true);
            Progress.UPDATE(); // Update the field in the dialog. 
        end;
        Progress.CLOSE();
        Message('Total Imported = %1', Counter);
    end;

    local procedure ImportExcelDataLines()
    var
        SLImportBuffer: Record "CVH Sale Line Import Buffer";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        LineType: Option "Item","G/L Account";
        Type: Text[50];
        No: Code[50];
        Description: Text[250];
        DocNo: Code[50];
        qty: Decimal;
        UnitPrice: Decimal;
        LineQty: Decimal;
        UOM: Code[24];
        Variant: Code[24];
        bincode: code[20];
        LineDiscountAmount: Decimal;
        ShortCutDim1: Code[50];
        ShortCutDim2: Code[50];
        DocumentType: Code[20];
        LocationCode: Code[50];
        GeneralProductPostingGroup: Code[50];
        departmentcod: Code[20];
        projectcode: code[20];
        //dialog
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Importing Sales Lines\Order No.: #1#####\No.: #2#####\Record Count: #3#####';

    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        SLImportBuffer.Reset();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;
        if TempExcelBuffer.FindSet() then
            RecordCounted := TempExcelBuffer.Count;
        Progress.OPEN(ProgressMsg, SLImportBuffer."Document No.", SLImportBuffer."No.", Counter);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin
            Evaluate(Type, GetValueAtCell(RowNo, 1));
            Evaluate(DocumentType, GetValueAtCell(RowNo, 2));
            Evaluate(DocNo, GetValueAtCell(RowNo, 3));
            Evaluate(No, GetValueAtCell(RowNo, 4));
            Evaluate(Description, GetValueAtCell(RowNo, 5));
            Evaluate(Variant, GetValueAtCell(RowNo, 6));
            Evaluate(qty, GetValueAtCell(RowNo, 7));
            Evaluate(LocationCode, GetValueAtCell(RowNo, 8));
            Evaluate(bincode, GetValueAtCell(RowNo, 9));
            Evaluate(UnitPrice, GetValueAtCell(RowNo, 10));
            Evaluate(UOM, GetValueAtCell(RowNo, 11));
            Evaluate(LineDiscountAmount, GetValueAtCell(RowNo, 12));
            Evaluate(GeneralProductPostingGroup, GetValueAtCell(RowNo, 13));
            Evaluate(departmentcod, GetValueAtCell(RowNo, 14));
            Evaluate(projectcode, GetValueAtCell(RowNo, 15));
            Counter := Counter + 1;//update dialog
            if SLImportBuffer.FindLast() then
                LineNo := SLImportBuffer."Line No." + 10000
            else
                LineNo := 10000;
            SLImportBuffer.Init();
            //SLImportBuffer.SetHideValidationDialog(true);
            SLImportBuffer."Line No." := LineNo;
            SLImportBuffer.Type := Type;
            SLImportBuffer."Document Type" := DocumentType;
            SLImportBuffer."Document No." := DocNo;
            SLImportBuffer."No." := No;
            SLImportBuffer.Description := Description;
            SLImportBuffer."Variant Code" := Variant;
            SLImportBuffer.Qty := qty;
            SLImportBuffer."Location Code" := LocationCode;
            SLImportBuffer."Bin Code" := bincode;
            SLImportBuffer."Unit Price Includ. Vat" := UnitPrice;
            SLImportBuffer."Unit Of Measure Code" := UOM;
            SLImportBuffer."Line Discount Amount" := LineDiscountAmount;
            SLImportBuffer."Gen. Prod. Posting Group" := GeneralProductPostingGroup;
            SLImportBuffer."Department Code" := departmentcod;
            SLImportBuffer."Project Code" := projectcode;
            SLImportBuffer.Insert();
            SLImportBuffer.Modify(true);
            Progress.UPDATE(); // Update the field in the dialog. 
            SLEEP(50);
        end;
        Progress.CLOSE();
        Message('Total Sales Lines Imported = %1', Counter);
    end;

    local procedure UpdateSellToCustomerNo(DocNo: Code[50]): Code[24]
    var
        SalesInvoiceHeader: Record "Sales Header";
    begin
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("No.", DocNo);
        if SalesInvoiceHeader.Find('-') then
            exit(SalesInvoiceHeader."Sell-to Customer No.");
    end;

    local procedure UpdateGenBusPostingGrp(CustomerNo: Code[50]): Code[50]
    var
        Cus: Record Customer;
    begin
        Cus.SetRange("No.", CustomerNo);
        if Cus.Find('-') then
            exit(Cus."Gen. Bus. Posting Group");
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
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        SalesInvoiceLineLbl: Label 'Sales Line';
        SalesInvoiceHeaderLbl: Label 'Sales Header';
}
