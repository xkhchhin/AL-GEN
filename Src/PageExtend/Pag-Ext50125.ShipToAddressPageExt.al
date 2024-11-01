pageextension 50125 ShipToAddressPageExt extends "Ship-to Address"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Contact No."; Rec."Contact No.")
            {
                ApplicationArea = All;
            }
            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = all;
            }
        }
        modify(Contact)
        {
            Visible = false;
        }
    }

}
