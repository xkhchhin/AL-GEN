page 50125 "'Amount Flow'"
{
    ApplicationArea = All;
    Caption = 'Amount Flow';
    PageType = List;
    SourceTable = "Amount Flow";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(SalesPeople; Rec.SalesPeople)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SalesPeople field.', Comment = '%';
                }
                field("Amount(LCY)"; Rec."Amount(LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount(LCY) field.', Comment = '%';
                }
                field("Sum Amount(LCY)"; SumAmountIncludingVAT(rec.SalesPeople))
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    procedure SumAmountIncludingVAT(SalesPeople: code[20]): Decimal
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        //SalesInvoiceHeader.SetRange("No.", Code);
        SalesInvoiceHeader.SetRange("Salesperson Code", SalesPeople);
        if SalesInvoiceHeader.FindSet() then begin
            repeat
                SalesInvoiceHeader.CalcFields("Amount Including VAT");
                TotalAmount += SalesInvoiceHeader."Amount Including VAT";
            until SalesInvoiceHeader.Next() = 0;
        end;
        exit(TotalAmount);
    end;
}
