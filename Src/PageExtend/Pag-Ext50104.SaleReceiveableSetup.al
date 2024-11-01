pageextension 50104 "Sale & Receiveable Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Number Series")
        {
            group("Enhenment Setup")
            {
                field("pmt. discount account"; Rec."pmt. discount account")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
            }
        }
    }
}
