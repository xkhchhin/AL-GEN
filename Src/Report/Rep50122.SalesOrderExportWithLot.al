report 50122 SalesOrderExportWithLot
{
    Caption = 'Sales Order Export With Lot';
    ApplicationArea = All;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            column(No; "No.")
            {
            }
            // dataitem("Sales Line"; "Sales Line")
            // {
            //     DataItemLinkReference = "Sales Header";
            //     DataItemLink = "Document No." = field("No.");
            //     RequestFilterFields = "Posting Date", "Document No.", "Responsibility Center";
            //     column(Posting_Date; "Posting Date")
            //     {
            //     }
            //     column(Document_No_; "Document No.") { }
            //     dataitem("Reservation Entry"; "Reservation Entry")
            //     {
            //         DataItemLinkReference = "Sales Line";
            //         DataItemLink = "Source ID" = field("Document No.");
            //     }
            // }
            trigger OnAfterGetRecord()
            begin
                SalesLineExport.Reset();
                ReservationEntry.Reset();
                SalesLineExport.SetRange("Posting Date", "Posting Date");
                ReservationEntry.SetFilter("Source ID", '%1', "No.");
                SalesLineExport.SetFilter("Document No.", "No.");
                ExportToExcel("Sales Header", SalesLineExport, "ReservationEntry");
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
                    field(getLotno; getLotno)
                    {
                        ApplicationArea = Base, Suite;
                        Caption = 'Lot No. and Expiry Date';
                    }
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        ToCompany := CompanyName;
    end;

    local procedure ExportToExcel(var SalesOrderHeader: Record "Sales Header"; var SalesOrderLine: Record "Sales Line"; var ReservationEntry: Record "Reservation Entry")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Sales Header';
        ExcelFileName: Label 'Sales Order Template Export_%1__%2';
        TempExcelBufferLine: Record "Excel Buffer" temporary;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Processing Order: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin

        //Export Header
        RecordCounted := SalesOrderHeader.Count;
        Progress.OPEN(ProgressMsg, SalesOrderHeader."No.", Counter, RecordCounted);//progress dialog open
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Sell-to Customer No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Sell-to Customer Name"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Payment Terms Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Shortcut Dimension 1 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Shortcut Dimension 2 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Due Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("External Document No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderHeader.FieldCaption("Responsibility Center"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        //SalesOrderHeader.SetRange("Document Type", SalesOrderHeader."Document Type"::Invoice);
        if SalesOrderHeader.Find('-') then
            repeat
                Counter := Counter + 1;//update dialog

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SalesOrderHeader."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Sell-to Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Sell-to Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Due Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesOrderHeader."External Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderHeader."Responsibility Center", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                Progress.UPDATE(); // Update the field in the dialog. 
                SLEEP(50);
            until SalesOrderHeader.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet('Sales Header', CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
        //Export Lines
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption(Type), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption(Description), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Variant Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption(Quantity), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Location Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Bin Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Unit Price"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Unit of Measure Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Line Discount Amount"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Gen. Prod. Posting Group"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Shortcut Dimension 1 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesOrderLine.FieldCaption("Shortcut Dimension 2 Code"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        //SalesOrderLine.SetRange("Posting Date", SalesOrderHeader."Posting Date");
        //SalesOrderLine.SetRange("Document No.", SalesOrderHeader."No.");
        //SalesOrderLine.CopyFilters(SalesOrderHeader);
        if SalesOrderLine.Find('-') then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SalesOrderLine.Type, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Variant Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesOrderLine."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Bin Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesOrderLine."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Line Discount Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesOrderLine."Gen. Prod. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesOrderLine."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until SalesOrderLine.Next() = 0;
        TempExcelBuffer.SelectOrAddSheet(SalesOrderLineLbl);
        TempExcelBuffer.WriteSheet(SalesOrderLineLbl, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
        if (getLotno = true) then begin
            //Export Lot
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.ClearNewRow();
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('Document No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Document Line No.', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Item No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Lot No."), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption(Quantity), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(ReservationEntry.FieldCaption("Expiration Date"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
            if ReservationEntry.Find('-') then
                repeat
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(ReservationEntry."Source ID", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(ReservationEntry."Source Ref. No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(ReservationEntry."Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(ReservationEntry."Lot No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(ReservationEntry."Quantity (Base)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(ReservationEntry."Expiration Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);

                until ReservationEntry.Next() = 0;
            TempExcelBuffer.SelectOrAddSheet('Lot Info');
            TempExcelBuffer.WriteSheet('Lot Info', CompanyName, UserId);
            //end of export SN
        end;

        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
        Progress.CLOSE();
        Message('Total Sales Document Exported = %1', Counter);
    end;

    var
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelHeaderImportSucess: Label 'Sales Header with document type Order is successfully imported.';
        ExcelLineImportSucess: Label 'Sales Line with document type Order is successfully imported.';
        SalesOrderLineLbl: Label 'Sales Line';
        SalesOrderHeaderLbl: Label 'Sales Header';
        SaleOrderNo: Code[20];
        ReservationEntry: Record "Reservation Entry";
        getLotno: Boolean;
        SalesLineExport: Record "Sales Line";
}
