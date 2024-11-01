page 50120 "Item Expiration Category"
{
    ApplicationArea = All;
    Caption = 'Item Expiration Category';
    PageType = List;
    SourceTable = "Item Expiration Category";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("No. Of Item"; Rec."No. Of Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Of Item field.', Comment = '%';
                }
            }
        }
    }
}
