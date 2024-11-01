pageextension 50141 "Assembly Order Sub Form" extends "Assembly Order Subform"
{
    layout
    {
        addafter("Remaining Quantity")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
        modify("Quantity per")
        {
            ApplicationArea = all;
            Editable = false;
        }
    }
    trigger OnOpenPage()
    var
        CompanyName: Text;
    begin
        CompanyName := Rec.CurrentCompany;
        AccessControl.Reset();
        AccessControl.SetRange("User Security ID", UserSecurityId());
        AccessControl.SetRange("Role ID", '');
        AccessControl.SetRange(Scope, AccessControl.Scope::System);
        AccessControl.SetRange("Company Name", CompanyName);
        if not AccessControl.IsEmpty then
            QauntiityPer := true
        else
            QauntiityPer := false;

    end;

    var
        AccessControl: Record "Access Control";
        QauntiityPer: Boolean;

}
