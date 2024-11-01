table 50103 KhmerLabel
{
    Caption = 'Khmer Label';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "English Description"; Text[150])
        {
            Caption = 'English Description';
        }
        field(3; "Khmer Description"; Text[150])
        {
            Caption = 'Khmer Description';
        }
        field(4; "Label Type"; Option)
        {
            Caption = 'Lable type';
            OptionMembers = "User Defined","System";
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
