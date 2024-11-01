pageextension 50111 SalesOrderCard extends "Sales Order"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Loan Amount"; Rec."Loan Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action(ExortToExcel)
            {
                Caption = 'Export Template';
                ApplicationArea = All;
                Image = ExportToExcel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Export: report "Sales Order Export";
                    Saleorder: Record "Sales Header";
                    SaleorderLine: Record "Sales Line";
                begin
                    Saleorder.SetRange("No.", rec."No.");
                    SaleorderLine.SetRange("Document No.", rec."No.");
                    if Saleorder.Find('-') then
                        Export.SetTableView(Saleorder);
                    if SaleorderLine.Find('-') then
                        Export.SetTableView(SaleorderLine);
                    Export.Run();
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
                    if SaleorderLine.Find('-') then
                        Export.SetTableView(SaleorderLine);
                    Export.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        Customer.Reset();
        Customer.SetRange("No.", Rec."Sell-to Customer No.");
        if Customer.Find('-') then
            //bring loan amount from customer to loan amount in sale order
            Rec."Loan Amount" := Customer."Loan Amount";
    end;


}
