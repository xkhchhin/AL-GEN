pageextension 50110 CustomerCard extends "Customer Card"
{
    layout
    {
        addafter("Balance Due (LCY)")
        {
            field("Loan Amount"; Rec."Loan Amount")
            {
                ApplicationArea = all;
            }
        }
    }
}
