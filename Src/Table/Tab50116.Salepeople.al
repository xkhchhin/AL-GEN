table 50116 Salepeople
{
    Caption = 'Salepeople';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; "Salepeople code"; Code[20])
        {
            Caption = 'Salepeople Code';
            NotBlank = true;
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                SetSalepeopleFields;
            end;
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            Editable = false;
        }
        field(5; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Cust. Ledger Entry"."Amount (LCY)" WHERE("Salesperson Code" = FIELD("Salepeople code")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "User ID", "Salepeople code")
        {
            Clustered = true;
        }
        key(Key2; Name)
        {
        }
        key(Key3; "Phone No.")
        {
        }
    }
    procedure SetSalepeopleFields()
    var
        Salepeople: Record "Salesperson/Purchaser";
    begin
        if Salepeople.Get("Salepeople code") then begin
            Name := Salepeople.Name;
            "Phone No." := Salepeople."Phone No.";
        end;
    end;
}
