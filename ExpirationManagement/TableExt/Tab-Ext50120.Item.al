tableextension 50120 Item extends Item
{
    fields
    {
        field(50100; "Item Expiration Category"; Code[20])
        {
            Caption = 'Item Expiration Category';
            DataClassification = ToBeClassified;
            TableRelation = "Item Expiration Category".Code;
        }
    }
}
