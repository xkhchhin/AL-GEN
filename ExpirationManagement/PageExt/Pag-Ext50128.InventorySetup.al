pageextension 50128 "Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group("Expiration Feature")
            {
                field("Exp. Category Feature"; Rec."Exp. Category Feature")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
