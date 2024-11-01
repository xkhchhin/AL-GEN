pageextension 50116 SaleOrderList extends "Sales Order List"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = false;
        }
    }
    actions
    {
        addafter("Print Confirmation")
        {
            action(PrintSelectLayout)
            {
                ApplicationArea = All;
                Caption = 'Print Selected Layout', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Print;

                trigger OnAction()
                var
                    ReportLayoutSelection: Record "Report Layout Selection";
                    SaleHeader: Record "Sales Header";
                    Selection: Integer;
                    SaleInvoiceLayout: Label 'Sale Invoice 1, Sale Invoice 2';
                begin
                    SaleHeader.Reset();
                    CurrPage.SetSelectionFilter(SaleHeader);
                    Selection := StrMenu(SaleInvoiceLayout);
                    case Selection of
                        1:
                            ReportLayoutSelection.SetTempLayoutSelected('1306-000002');
                        2:
                            ReportLayoutSelection.SetTempLayoutSelected('1306-000001');
                        else
                            exit;
                    end;
                    Report.Run(Report::"Standard Sales - Order Conf.", true, true, SaleHeader);
                end;
            }
        }
        addfirst(Processing)
        {
            action(PrintOrder)
            {
                ApplicationArea = All;//property specifies that the action is available in all application areas
                Caption = 'Print Order', comment = '="YourLanguageCaption"';//specifies the caption of the action.
                Promoted = true;//property specifies that the action is displayed in the promoted actions bar.
                PromotedCategory = Process;//property specifies the category of the promoted action.
                PromotedIsBig = true;//property specifies that the promoted action is a large button.
                Image = PrintDocument;//property specifies the image that is displayed next to the action.

                trigger OnAction()//is called when the user clicks the action
                var
                //SaleOrderReport: Report SalesOrderConfCVH;
                begin
                    //SaleOrderReport.Run();
                end;
            }
            action(ExortToExcelLot)
            {
                Caption = 'Export Order With Lot';
                ApplicationArea = All;
                Image = ExportToExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Export: report SalesOrderExportWithLot;
                    Saleorder: Record "Sales Header";
                    SaleorderLine: Record "Sales Line";
                begin
                    Saleorder.SetRange("No.", rec."No.");
                    SaleorderLine.SetRange("Document No.", rec."No.");
                    if Saleorder.Find('-') then
                        Export.SetTableView(Saleorder);
                    // if SaleorderLine.Find('-') then
                    //     Export.SetTableView(SaleorderLine);
                    Export.Run();
                end;
            }
            action(ImportFromExcel)
            {
                Caption = 'Import Template With Lot';
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    ReadExcelSheet();
                end;
            }
        }
    }
    ///-------Import----------///
    local procedure ReadExcelSheet()
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

                    IF SheetName = SalesInvoiceLineLbl THEN
                        ImportExcelDataLines();
                    IF SheetName = SalesInvoiceHeaderLbl THEN
                        ImportExcelDataHeader();
                    IF SheetName = ReservationLbl then
                        ImportReservationEntry();
                until NameValueBufferOut.Next() = 0;
            end;
        end else begin
            Message('File is not found');
        end;
    end;


    local procedure ReadExcelSheetHeader()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        SheetName := '';
        FileName := '';
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
        SheetName := TempExcelBuffer.SelectSheetsNameStream(Istream);
        IF SheetName = SalesInvoiceHeaderLbl THEN
            ImportExcelDataHeader();
    end;

    local procedure ReadExcelSheetLine()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        SheetName := '';
        FileName := '';
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
        SheetName := TempExcelBuffer.SelectSheetsNameStream(Istream);
        IF SheetName = SalesInvoiceLineLbl THEN
            ImportExcelDataLines();
    end;

    local procedure ImportExcelDataHeader()
    var
        SHImportBuffer: Record "Sales Header";
        SLImportBuffer: Record "Sales Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Sales Order Header Importing\Order No.: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin
        //importheader
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        SHImportBuffer.Reset();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;
        if TempExcelBuffer.FindSet() then
            RecordCounted := TempExcelBuffer.Count;
        Progress.OPEN(ProgressMsg, SHImportBuffer."No.", Counter, RecordCounted);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin
            Counter := Counter + 1;//update dialog
            LineNo := LineNo + 10000;
            SHImportBuffer.Init();
            Evaluate(SHImportBuffer."Document Type", GetValueAtCell(RowNo, 1));
            Evaluate(SHImportBuffer."No.", GetValueAtCell(RowNo, 2));
            Evaluate(SHImportBuffer."Sell-to Customer No.", GetValueAtCell(RowNo, 3));
            Evaluate(SHImportBuffer."Sell-to Customer Name", GetValueAtCell(RowNo, 4));
            Evaluate(SHImportBuffer."Document Date", GetValueAtCell(RowNo, 5));
            Evaluate(SHImportBuffer."Posting Date", GetValueAtCell(RowNo, 6));
            Evaluate(SHImportBuffer."Payment Terms Code", GetValueAtCell(RowNo, 7));
            Evaluate(SHImportBuffer."Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 8));
            Evaluate(SHImportBuffer."Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 9));
            Evaluate(SHImportBuffer."Location Code", GetValueAtCell(RowNo, 10));
            Evaluate(SHImportBuffer."Due Date", GetValueAtCell(RowNo, 11));
            Evaluate(SHImportBuffer."External Document No.", GetValueAtCell(RowNo, 12));
            Evaluate(SHImportBuffer."Responsibility Center", GetValueAtCell(RowNo, 13));
            SHImportBuffer."Gen. Bus. Posting Group" := UpdateGenBusPostingGrp(SHImportBuffer."Sell-to Customer No.");
            SHImportBuffer."VAT Bus. Posting Group" := VATBusPostingGrp(SHImportBuffer."Sell-to Customer No.");
            SHImportBuffer.Insert();
            SHImportBuffer.Validate("Sell-to Customer No.", GetValueAtCell(RowNo, 3));
            SHImportBuffer.Validate("Posting Date");
            SHImportBuffer.CopySellToAddressToBillToAddress();
            SHImportBuffer.CopySellToAddressToShipToAddress();
            SHImportBuffer.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 8));
            SHImportBuffer.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 9));
            SHImportBuffer.Validate("Gen. Bus. Posting Group");
            SHImportBuffer.Validate("Customer Posting Group");
            SHImportBuffer.Validate("Responsibility Center", GetValueAtCell(RowNo, 14));
            SHImportBuffer.Imported := true;
            SHImportBuffer."Imported DateTime" := CurrentDateTime;
            SHImportBuffer."Imported ByuserID" := UserId;
            SHImportBuffer.Modify(true);
            Progress.UPDATE(); // Update the field in the dialog. 
            SLEEP(50);
        end;
        Progress.CLOSE();
        Message('Total Sales Order Imported = %1', Counter);
    end;

    local procedure TestingConnection()
    begin
        Message('');
    end;

    local procedure ImportExcelDataLines()
    var
        SLImportBuffer: Record "Sales Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        LineType: Option "Item","G/L Account";
        No: Code[50];
        Description: Text[250];
        DocNo: Code[50];
        UnitPrice: Decimal;
        LineQty: Decimal;
        UOM: Code[24];
        Variant: Code[24];
        LineDiscountAmount: Decimal;
        ShortCutDim1: Code[50];
        ShortCutDim2: Code[50];
        DocumentType: Option "Invoice";
        LocationCode: Code[50];
        GeneralProductPostingGroup: Code[50];
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

            Counter := Counter + 1;//update dialog

            DocNo := GetValueAtCell(RowNo, 3);
            SLImportBuffer.SetRange("Document No.", DocNo);
            Evaluate(LineQty, GetValueAtCell(RowNo, 7));
            Evaluate(UnitPrice, GetValueAtCell(RowNo, 10));
            Evaluate(LineDiscountAmount, GetValueAtCell(RowNo, 12));
            if SLImportBuffer.FindLast() then
                LineNo := SLImportBuffer."Line No." + 10000
            else
                LineNo := 10000;
            SLImportBuffer.Init();
            SLImportBuffer.SetHideValidationDialog(true);
            SLImportBuffer."Line No." := LineNo;
            Evaluate(SLImportBuffer."Type", GetValueAtCell(RowNo, 1));
            Evaluate(SLImportBuffer."Document Type", GetValueAtCell(RowNo, 2));
            Evaluate(SLImportBuffer."Document No.", DocNo);
            Evaluate(SLImportBuffer."No.", GetValueAtCell(RowNo, 4));
            Evaluate(SLImportBuffer.Description, GetValueAtCell(RowNo, 5));
            Evaluate(SLImportBuffer."Variant Code", GetValueAtCell(RowNo, 6));
            Evaluate(SLImportBuffer.Quantity, GetValueAtCell(RowNo, 7));
            Evaluate(SLImportBuffer."Location Code", GetValueAtCell(RowNo, 8));
            Evaluate(SLImportBuffer."Bin Code", GetValueAtCell(RowNo, 9));
            Evaluate(SLImportBuffer."Unit Price", GetValueAtCell(RowNo, 10));
            Evaluate(SLImportBuffer."Unit of Measure Code", GetValueAtCell(RowNo, 11));
            Evaluate(SLImportBuffer."Line Discount Amount", GetValueAtCell(RowNo, 12));
            Evaluate(SLImportBuffer."Gen. Prod. Posting Group", GetValueAtCell(RowNo, 13));
            Evaluate(SLImportBuffer."Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 14));
            Evaluate(SLImportBuffer."Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 15));
            SLImportBuffer."Sell-to Customer No." := UpdateSellToCustomerNo(SLImportBuffer."Document No.");
            SLImportBuffer."Gen. Bus. Posting Group" := UpdateGenBusPostingGrp(SLImportBuffer."Sell-to Customer No.");
            SLImportBuffer.Insert();
            SLImportBuffer.Validate("No.", GetValueAtCell(RowNo, 4));
            SLImportBuffer.Validate(Description, GetValueAtCell(RowNo, 5));
            SLImportBuffer.Validate("Variant Code", GetValueAtCell(RowNo, 6));
            SLImportBuffer.Validate("Location Code", GetValueAtCell(RowNo, 8));
            SLImportBuffer.validate(Quantity, LineQty);
            SLImportBuffer.validate("Unit Price", UnitPrice);
            SLImportBuffer.Validate("Line Discount Amount", LineDiscountAmount);
            SLImportBuffer.Validate("Gen. Prod. Posting Group", GetValueAtCell(RowNo, 13));
            SLImportBuffer.validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 14));
            SLImportBuffer.validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 15));
            SLImportBuffer.Modify(true);
            Progress.UPDATE(); // Update the field in the dialog. 
            SLEEP(50);
        end;
        Progress.CLOSE();
        Message('Total Sales Lines Imported = %1', Counter);
    end;

    local procedure ImportReservationEntry()
    var
        SalesLine: Record "Sales Line";
        ReservationEntry: Record "Reservation Entry";
        RowNo: Integer;
        ColNo: Integer;
        ItemNo: code[20];
        Qty: Decimal;
        LineNo: Integer;
        ExpirationDate: Date;
        LotNo: Code[24];
        MaxRowNo: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        LastEntryNo: Integer;
        DocNo: Code[20];
        I: Integer;
        LocationCode: Code[20];
        ProgressMsg: Label 'Importing Reservation Entry\No.: #1#####\Record Count: #2#####';
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;
        if TempExcelBuffer.FindSet() then
            RecordCounted := TempExcelBuffer.Count;
        Progress.OPEN(ProgressMsg, ReservationEntry."Lot No.", Counter, RecordCounted);//progress dialog open
        ReservationEntry.SetRange("Location Code", SalesLine."Location Code");
        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            //arrange the excel sheet
            Evaluate(DocNo, GetValueAtCell(RowNo, 1));
            Evaluate(LineNo, GetValueAtCell(RowNo, 2));
            Evaluate(ItemNo, GetValueAtCell(RowNo, 3));
            Evaluate(LotNo, GetValueAtCell(RowNo, 4));
            Evaluate(Qty, GetValueAtCell(RowNo, 5));
            Evaluate(ExpirationDate, GetValueAtCell(RowNo, 6));
            Evaluate(LocationCode, GetValueAtCell(RowNo, 7));
            //arrange the excel sheet
            Counter := Counter + 1;//update dialog
            ReservationEntry.Reset();
            ReservationEntry.Init();
            ReservationEntry."Entry No." := NextEntryNo;
            ReservationEntry."Item No." := ItemNo;
            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
            ReservationEntry."Source Batch Name" := '';
            ReservationEntry."Source Type" := Database::"Sales Line";
            ReservationEntry."Source Subtype" := ReservationEntry."Source Subtype"::"1";
            ReservationEntry."Source ID" := DocNo;
            ReservationEntry."Source Ref. No." := LineNo;
            ReservationEntry."Quantity (Base)" := Qty;
            ReservationEntry."Lot No." := LotNo;
            ReservationEntry."Expiration Date" := ExpirationDate;
            ReservationEntry."Location Code" := LocationCode;
            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
            ReservationEntry."Created By" := UserId;
            ReservationEntry.Positive := false;
            ReservationEntry."Creation Date" := WorkDate();
            ReservationEntry.Insert(true);
            ReservationEntry.Validate("Source ID", DocNo);
            ReservationEntry.Validate("Source Ref. No.", LineNo);
            ReservationEntry.Validate("Item No.", ItemNo);
            ReservationEntry.Validate(Quantity, Qty);
            ReservationEntry.Validate("Quantity (Base)", Qty);
            ReservationEntry.Validate("Lot No.", LotNo);
            ReservationEntry.Validate("Expiration Date", ExpirationDate);
            ReservationEntry.Validate("Location Code", LocationCode);
            ReservationEntry.Modify(true);
            Progress.UPDATE(); // Update the field in the dialog.
        end;
        Progress.CLOSE();
        Message('Lots Imported = %1', Counter);
    end;

    local procedure NextEntryNo(): Integer
    var
        ReserveEntry: Record "Reservation Entry";
    begin
        ReserveEntry.Reset();
        if LastEntryNo = 0 then
            if ReserveEntry.FindLast() then
                LastEntryNo := ReserveEntry."Entry No.";
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
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

    local procedure VATBusPostingGrp(CustomerNo: Code[50]): Code[50]
    var
        Cus: Record Customer;
    begin
        Cus.SetRange("No.", CustomerNo);
        if Cus.Find('-') then
            exit(Cus."VAT Bus. Posting Group");
    end;

    var
        ImportVisible: Boolean;
        AccessControl: Record "Access Control";
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelHeaderImportSucess: Label 'Sales Header with document type Order is successfully imported.';
        ExcelLineImportSucess: Label 'Sales Line with document type Order is successfully imported.';
        SalesInvoiceLineLbl: Label 'Sales Line';
        SalesInvoiceHeaderLbl: Label 'Sales Header';
        ReservationLbl: Label 'Lot Info';
        LastEntryNo: Integer;

    //test check file size
}
