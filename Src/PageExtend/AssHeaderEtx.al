pageextension 50142 AssemblyHeader extends "Assembly Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Remaining Quantity")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}