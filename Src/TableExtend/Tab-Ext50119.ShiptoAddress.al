tableextension 50119 "Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50100; "Contact Name"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(50101; "Contact No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact."No.";  // Link to the Contact table
            trigger OnValidate()
            var
                Contact: Record Contact;
            begin
                if "Contact No." <> '' then begin
                    Contact.Get("Contact No.");
                    "Contact Name" := Contact.Name;
                end;
            end;
        }
    }
}
