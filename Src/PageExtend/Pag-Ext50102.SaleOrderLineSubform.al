pageextension 50102 SaleOrderLineSubform extends "Sales Order Subform"
{
    layout
    {
        addafter("Bin Code")
        {
            field(TID; Rec.TID)
            {
                Visible = true;
                ApplicationArea = all;
            }
            field(test; Rec.test)
            {
                ApplicationArea = all;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}
