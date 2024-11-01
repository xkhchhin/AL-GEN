report 50128 "Purchase Statement"
{
    ApplicationArea = All;
    Caption = 'Purchase Statement';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Src/LayoutReport/PurchaseStatement.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Date Filter";
            column(No_; "No.") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(PurchaseStatementFilter; PurchaseStatementFilter) { }
            column(ComanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(LineQuantity; Quantity)
                {
                }
                column(LineItemNo_; "No.") { }
                column(Qty__to_Receive; "Qty. to Receive") { }
                dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                {
                    DataItemLink = "Order No." = field("Document No."), "No." = field("No."), "Order Line No." = field("Line No.");
                    column(Posting_Date; "Posting Date") { }
                    column(Document_No_; "Document No.") { }
                    column(Order_No_; "Order No.") { }
                    column(Order_Line_No_; "Order Line No.") { }
                    column(ItemNo_; "No.") { }
                    column(Description; Description) { }
                    column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                    column(Quantity; Quantity) { }

                    column(OpeningBalance2; OpeningBalance2) { }
                    column(OpeningBalance; OpeningBalance) { }
                    trigger OnAfterGetRecord()
                    begin
                        OpeningBalance := OpeningBalance - "Purch. Rcpt. Line".Quantity;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    OpeningBalance := 0;
                    OpeningBalance := Quantity;
                    OpeningBalance2 := OpeningBalance;
                end;
                //end;
            }
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        PurchaseStatementFilter := "Purchase Header".GetFilters;
    end;

    var
        PurchaseStatementFilter: Text[60];
        OpeningBalance: Decimal;
        OpeningBalance2: Decimal;
        CalQuantity: Decimal;
}
