pageextension 50115 "Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    actions
    {
        addfirst(processing)
        {
            action(PrintPayment)
            {
                ApplicationArea = All;
                Caption = 'Print Payment', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PrintDocument;

                trigger OnAction()
                var
                    SaleInvoiceReport: Report OfficialreceiptCVH;
                begin
                    SaleInvoiceReport.Run();
                end;
            }
            action("PrintPayment(Chhein)")
            {
                ApplicationArea = All;
                Caption = 'Print Payment (Chhein)', comment = '="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = PrintDocument;

                trigger OnAction()
                var
                    SaleInvoiceReport: Report PaymentRecieptCVH;
                begin
                    SaleInvoiceReport.Run();
                end;
            }
        }
    }
}
