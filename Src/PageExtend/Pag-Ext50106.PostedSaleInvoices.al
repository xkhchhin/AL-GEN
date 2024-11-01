pageextension 50106 "Posted Sale Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        addfirst(processing)
        {
            action(PrintInvoice)
            {
                ApplicationArea = All;
                Caption = 'Print Invoice', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PrintDocument;

                trigger OnAction()
                var
                    SaleInvoiceReport: Report SalesInvoiceCVH;
                begin
                    SaleInvoiceReport.Run();
                end;
            }
        }
    }
}
