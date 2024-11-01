pageextension 50124 "Bank Account List" extends "Bank Account List"
{
    layout
    {
        addafter(Contact)
        {
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = all;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}
