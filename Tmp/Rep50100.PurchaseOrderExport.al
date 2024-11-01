report 50100 "Purchase Order Export"
{
    Caption = 'Purchase Order Export';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            column(No; "No.")
            {
            }
            trigger OnAfterGetRecord()
            begin

                PurchaseLineExport.Reset();
                ReservationEntry.Reset();
                PurchaseLineExport.SetFilter("Document No.", "No.");
                ReservationEntry.SetFilter("Source ID", '%1', "No.");
                ExportToExcel("Purchase Header", PurchaseLineExport, "ReservationEntry");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Include';
                    field(getno; getno)
                    {
                        ApplicationArea = Base, Suite;
                        Caption = ' No. and Expiry Date';
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        ToCompany := CompanyName;
    end;

    local procedure ExportToExcel(var PurchaseOrderHeader: Record "Purchase Header"; var PurchaseOrderLine: Record "Purchase Line"; var ReservationEntry: Record "Reservation Entry")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Purchase Header';
        ExcelFileName: Label 'Purchase Order Template Export_%1__%2';
        TempExcelBufferLine: Record "Excel Buffer" temporary;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];

        ProgressMsg: Label 'Processing Invoice: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin

        RecordCounted := PurchaseOrderHeader.Count;
        Progress.OPEN(ProgressMsg, PurchaseOrderHeader."No.", Counter, RecordCounted);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderHeader.FieldCaption("Buy-from Vendor No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderHeader.FieldCaption("Buy-from Vendor Name"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderHeader.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderHeader.FieldCaption("Document Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderHeader.FieldCaption("Posting Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::text);
        TempExcelBuffer.AddColumn(PurchaseOrderHeader.FieldCaption("Payment Terms Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::text);
        "Purchase Header".SetRange("Document Type", "Purchase Header"."Document Type"::Order);
        if PurchaseOrderHeader.Find('-') then
            repeat
                Counter := Counter + 1;
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::text);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::text);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Buy-from Vendor No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Buy-from Vendor Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(PurchaseOrderHeader."Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                Progress.UPDATE();
                SLEEP(50);
            until PurchaseOrderHeader.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet('Purchase Header', CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption(Type), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption(Description), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Bin Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Quantity"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Unit of Measure Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Promised Receipt Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Planned Receipt Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PurchaseOrderLine.FieldCaption("Expected Receipt Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        if PurchaseOrderLine.Find('-') then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(PurchaseOrderLine.Type, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(PurchaseOrderLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Bin Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(PurchaseOrderLine.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Promised Receipt Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Planned Receipt Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Expected Receipt Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
            until PurchaseOrderLine.Next() = 0;
        TempExcelBuffer.SelectOrAddSheet(PurchaseOrderLineLbl);
        TempExcelBuffer.WriteSheet(PurchaseOrderLineLbl, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Line', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Item No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Lot No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Quantity (Base)"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Expiration Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::text);
        TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::text);
        if ReservationEntry.Find('-') then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."Line No.", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseOrderLine."No.", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ReservationEntry."Lot No.", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(ReservationEntry."Quantity (Base)", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(ReservationEntry."Expiration Date", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(ReservationEntry."Location Code", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            until ReservationEntry.Next() = 0;
        TempExcelBuffer.SelectOrAddSheet(PurchaseOrderLineLotLbl);
        TempExcelBuffer.WriteSheet(PurchaseOrderLineLotLbl, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
        Progress.CLOSE();
        Message('Total Purchase Header Exported = %1', Counter);
    end;

    var
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelHeaderImportSucess: Label 'Purchaser Order Header with document type is successfully imported.';
        ExcelLineImportSucess: Label 'Purachser Order Line with document type is successfully imported.';
        PurchaseOrderLineLbl: Label 'Purchase Order Line';
        PurchaseOrderHeaderLbl: Label 'Purchser Order Header';
        PurchaseOrderLineLotLbl: Label 'Lot Info';
        ReservationEntry: Record "Reservation Entry";
        getno: Boolean;
        PurchaseLineExport: Record "Purchase Line";
}
