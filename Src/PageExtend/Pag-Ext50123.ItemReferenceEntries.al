pageextension 50123 "Item Reference Entries" extends "Item Reference Entries"
{
    actions
    {
        addlast(Processing)
        {
            action(PrintLabel)
            {
                ApplicationArea = Basic, Suite;
                Image = Print;
                Caption = 'Print Label';
                ToolTip = 'Print Label';

                trigger OnAction()
                var
                    ItemReference: Record "Item Reference";
                    ReferenceNoLabel: Report "Reference No Label";
                begin
                    ItemReference := Rec;
                    CurrPage.SetSelectionFilter(ItemReference);
                    ReferenceNoLabel.SetTableView(ItemReference);
                    ReferenceNoLabel.RunModal();
                end;
            }
        }
    }
}
