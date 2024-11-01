report 50129 "Sales Invoices Export (XKH)"
{
    ApplicationArea = All;
    Caption = 'Sales Invoices Export (XKH)';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "Posting Date", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(No; "No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = "Sales Header";
                DataItemLink = "Document No." = field("No.");
                RequestFilterFields = "Posting Date", "Document No.", "Responsibility Center";
                column(Posting_Date; "Posting Date")
                {

                }
                column(Document_No_; "Document No.") { }
                trigger OnAfterGetRecord()
                begin
                    SetRange("Posting Date", "Sales Header"."Posting Date");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                ExportToExcel("Sales Header", "Sales Line");
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
                group(Export)
                {
                    field(ToCompany; ToCompany)
                    {
                        ApplicationArea = All;
                        Caption = 'From Company';
                        Editable = false;
                    }
                }

            }
        }
    }
    trigger OnInitReport()
    begin
        ToCompany := CompanyName;
    end;

    local procedure ExportToExcel(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Sales Header';
        ExcelFileName: Label 'Sales Template Export_%1__%2';
        TempExcelBufferLine: Record "Excel Buffer" temporary;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Processing Invoice: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin

        //Export Header
        RecordCounted := SalesHeader.Count;
        Progress.OPEN(ProgressMsg, SalesHeader."No.", Counter, RecordCounted);//progress dialog open
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document Type', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Sales No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Sell-to Customer No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Sell-to Customer Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Date', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Payment Terms Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Shortcut Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Shortcut Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Due Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("External Document No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting No. Series', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesHeader.FieldCaption("Responsibility Center"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        if SalesHeader.Find('-') then
            repeat
                Counter := Counter + 1;//update dialog

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Sell-to Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Sell-to Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesHeader."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesHeader."Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Due Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."No. Series", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesHeader."Responsibility Center", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                Progress.UPDATE(); // Update the field in the dialog. 
                SLEEP(50);
            until SalesHeader.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet('Sales Header', CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
        //Export Lines
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption(Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Sales No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption(Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Unit Price"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Unit of Measure Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Line Discount Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Gen. Prod. Posting Group"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Shortcut Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesLine.FieldCaption("Shortcut Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //SalesLine.SetRange("Posting Date", SalesHeader."Posting Date");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        //SalesLine.CopyFilters(SalesHeader);
        if SalesLine.Find('-') then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SalesLine.Type, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesLine."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesLine."Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesLine."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine."Line Discount Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesLine."Gen. Prod. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesLine."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until SalesLine.Next() = 0;
        TempExcelBuffer.SelectOrAddSheet(SalesLineLbl);
        TempExcelBuffer.WriteSheet(SalesLineLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
        Progress.CLOSE();
        Message('Total Sales Exported = %1', Counter);
    end;

    var
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelHeaderImportSucess: Label 'Sales Header with document type is successfully imported.';
        ExcelLineImportSucess: Label 'Sales Line with document type is successfully imported.';
        SalesLineLbl: Label 'Sales Line';
        SalesHeaderLbl: Label 'Sales Header';
}
