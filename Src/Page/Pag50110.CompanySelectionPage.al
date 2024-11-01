page 50110 CompanySelectionPage
{
    PageType = List;
    SourceTable = Company;
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Company Name"; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SelectCompany)
            {
                Caption = 'Select Company';
                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }
}
