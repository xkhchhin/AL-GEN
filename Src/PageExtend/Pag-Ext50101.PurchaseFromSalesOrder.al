pageextension 50101 "Purchase From Sales Order" extends "Purch. Order From Sales Order"
{
    layout
    {
        addafter(Quantity)
        {
            field(Margins; Rec.Margins)
            {
                Caption = 'Margins %';
                ApplicationArea = all;
                Visible = true;
            }
        }
    }
}
