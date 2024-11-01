pageextension 50120 "Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(test; Rec.test)
            {
                ApplicationArea = all;
            }
        }
    }
}
