pageextension 50140 "Item Card" extends "Item Card"
{
    layout
    {
        addbefore(ItemPicture)
        {
            part(XTRItemPicture; "XTR Item Picture Gallery")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
        addafter("Item Category Code")
        {
            field("Item Expiration Category"; Rec."Item Expiration Category")
            {
                ApplicationArea = all;
                Visible = EnableFeature;
            }
        }
    }
    trigger OnOpenPage()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        if InventorySetup."Exp. Category Feature" = true then
            EnableFeature := true
        else
            EnableFeature := false;
    end;

    var
        EnableFeature: Boolean;
}