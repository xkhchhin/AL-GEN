/// <summary>
/// Report LFR Sales Invoice Export (ID 50051).
/// </summary>
report 50108 "LFR Sales Invoice Export"
{
    ApplicationArea = All;
    Caption = 'LFR Sales Invoices Export Tool';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(No; "No.")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                RequestFilterFields = "Posting Date", "Document No.", "Responsibility Center";
                column(Posting_Date; "Posting Date")
                {

                }
                column(Document_No_; "Document No.") { }
                trigger OnAfterGetRecord()
                begin
                    SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                ExportToExcel("Sales Invoice Header", "Sales Invoice Line");
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

    local procedure ExportToExcel(var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesInvoiceLine: Record "Sales Invoice Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label 'Sales Invoice Header';
        ExcelFileName: Label 'Sales Invoice Template Export_%1__%2';
        TempExcelBufferLine: Record "Excel Buffer" temporary;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        I: Integer;
        InvoiceNo: Code[24];
        ProgressMsg: Label 'Processing Invoice: #1#####\Record Count: #2#####\Total Records Counted: #3#####';
    begin

        //Export Header
        RecordCounted := SalesInvoiceHeader.Count;
        Progress.OPEN(ProgressMsg, SalesInvoiceHeader."No.", Counter, RecordCounted);//progress dialog open
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document Type', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Sales Invoice No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Sell-to Customer No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Sell-to Customer Name"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Date', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Payment Terms Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Shortcut Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Shortcut Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Due Date"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("External Document No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting No. Series', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceHeader.FieldCaption("Responsibility Center"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //SalesInvoiceHeader.SetRange("Document Type", SalesInvoiceHeader."Document Type"::Invoice);
        if SalesInvoiceHeader.Find('-') then
            repeat
                Counter := Counter + 1;//update dialog

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Sell-to Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Sell-to Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Due Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."External Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."No. Series", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceHeader."Responsibility Center", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                Progress.UPDATE(); // Update the field in the dialog. 
                SLEEP(50);
            until SalesInvoiceHeader.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet('Sales Invoice Header', CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
        //Export Lines
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption(Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Sales Invoice No.', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption(Description), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption(Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Location Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Unit Price"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Unit of Measure Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Line Discount Amount"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Gen. Prod. Posting Group"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Shortcut Dimension 1 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Shortcut Dimension 2 Code"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        //SalesInvoiceLine.SetRange("Posting Date", SalesInvoiceHeader."Posting Date");
        //SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        //SalesInvoiceLine.CopyFilters(SalesInvoiceHeader);
        if SalesInvoiceLine.Find('-') then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SalesInvoiceLine.Type, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Line Discount Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Gen. Prod. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Shortcut Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesInvoiceLine."Shortcut Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until SalesInvoiceLine.Next() = 0;
        TempExcelBuffer.SelectOrAddSheet(SalesInvoiceLineLbl);
        TempExcelBuffer.WriteSheet(SalesInvoiceLineLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
        Progress.CLOSE();
        Message('Total Sales Invoice Exported = %1', Counter);
    end;

    var
        ToCompany: Text;
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ExcelHeaderImportSucess: Label 'Sales Header with document type Invoice is successfully imported.';
        ExcelLineImportSucess: Label 'Sales Line with document type Invoice is successfully imported.';
        SalesInvoiceLineLbl: Label 'Sales Invoice Line';
        SalesInvoiceHeaderLbl: Label 'Sales Invoice Header';
}


