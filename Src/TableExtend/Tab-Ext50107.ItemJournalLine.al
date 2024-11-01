tableextension 50107 "Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50100; "New Bin Code Cust"; code[20])
        {
            Caption = 'New Bin Code Cust';
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"),
                                            "Item Filter" = FIELD("Item No."),
                                            "Variant Filter" = FIELD("Variant Code"));

        }
        field(50101; OptionType; Enum OptionType)
        {
            Caption = 'Option Type';
            DataClassification = ToBeClassified;
        }
        field(50102; "Student Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Reclass to Location Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50104; "Reclass to Bin Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Entry Type" = FILTER(Purchase | "Positive Adjmt." | Output),
                                Quantity = FILTER(>= 0)) Bin.Code WHERE("Location Code" = FIELD("Location Code"),
                                                                      "Item Filter" = FIELD("Item No."),
                                                                      "Variant Filter" = FIELD("Variant Code"));
        }
        field(50105; "test"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
}
