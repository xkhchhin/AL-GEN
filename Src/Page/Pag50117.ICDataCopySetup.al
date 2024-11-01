page 50117 "IC Data Copy Setup"
{
    Caption = 'IC Data Copy Setup';
    PageType = Card;
    SourceTable = "IC Data Copy Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("From Company"; Rec."From Company")
                {
                }
                field("To Company"; Rec."To Company")
                {
                }
                field("Commit After Table Copy"; Rec."Commit After Table Copy")
                {
                }
                field(Active; Rec.Active)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CopySetup)
            {
                Caption = 'Setup';
            }
            action(Copy)
            {
                Caption = 'Copy';
            }
        }
    }
}
