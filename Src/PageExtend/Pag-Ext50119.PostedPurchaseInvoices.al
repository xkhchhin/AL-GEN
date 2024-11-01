pageextension 50119 "Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    actions
    {
        addfirst(processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Modify Invoice No.', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = EditLines;

                trigger OnAction()
                var
                    PostedPurchInv: Record "Purch. Inv. Header";
                    DialogPage: Page "Modify Invoice Dialog";
                    DialogRecord: Record "Purch. Inv. Header";
                    OldInvoiceNo: Code[20];
                    NewInvoiceNo: Code[20];
                begin
                    // Check if a record is selected
                    PostedPurchInv.Copy(Rec);
                    if PostedPurchInv.IsEmpty then
                        Error('Please select a posted purchase invoice.');

                    // Set old invoice number on dialog page
                    PostedPurchInv."No." := DialogRecord.OldInvoiceNo;

                    // Open the dialog page
                    if DialogPage.RunModal = Action::OK then begin
                        // Get the new invoice number from the dialog page
                        PostedPurchInv."No." := DialogRecord.OldInvoiceNo;
                        DialogRecord.NewInvoiceNo := DialogRecord.NewInvoiceNo;

                        // Call the procedure to modify the invoice number
                        ModifyInvoiceNo(PostedPurchInv."No.", NewInvoiceNo);
                    end;
                end;
            }
        }
    }
    procedure ModifyInvoiceNo(PostedInvoiceNo: Code[20]; NewInvoiceNo: Code[20])
    var
        PostedPurchInv: Record "Purch. Inv. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        Confirm: Boolean;
    begin
        // Find the posted purchase invoice by its current number
        if PostedPurchInv.Get(PostedInvoiceNo) then begin
            Confirm := Confirm(
                'Do you want to change the Posted Purchase Invoice No. from %1 to %2?',
                false, PostedInvoiceNo, NewInvoiceNo);

            if Confirm then begin
                if PostedPurchInv.Get(NewInvoiceNo) then
                    Error('The new invoice number %1 is already in use.', NewInvoiceNo);

                // Update the No. field
                PostedPurchInv."No." := NewInvoiceNo;
                PostedPurchInv.Modify();

                // If the number is linked to other related records, update them as well
                if PurchInvHeader.Get(PostedInvoiceNo) then begin
                    PurchInvHeader."No." := NewInvoiceNo;
                    PurchInvHeader.Modify();
                end;

                // Optional: Notify the user of success
                Message('The Posted Purchase Invoice No. has been changed from %1 to %2.', PostedInvoiceNo, NewInvoiceNo);
            end;
        end else
            Error('The Posted Purchase Invoice No. %1 could not be found.', PostedInvoiceNo);
    end;
}
