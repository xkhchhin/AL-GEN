pageextension 50127 "Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addafter("FA Location Code")
        {
            field("FA Location Name"; GetFALocationName(rec."FA Location Code"))
            {
                ApplicationArea = all;
            }
        }
    }
    local procedure GetFALocationName(FACode: Code[20]): Text[50]
    var
        FALocation: Record "FA Location";
    begin
        FALocation.Reset();
        FALocation.SetRange(Code, FACode);
        if FALocation.Find('-') then
            exit(FALocation.Name)
    end;
}
