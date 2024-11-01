pageextension 50122 "Customer List" extends "Customer List"
{
    actions
    {
        addafter("&Customer")
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Test Transfer Fields', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TransferOrder;

                trigger OnAction()
                begin
                    TransferSerialInformationData();
                end;
            }
        }
    }

    procedure TransferSerialInformationData(SourceCompany: Code[50]; TargetCompany: Code[50])
    var
        SerialInfoSource: Record "Customer";
        SerialInfoTarget: Record "Customer";
    begin
        // Set the company to the source company
        SerialInfoSource.CHANGECOMPANY(SourceCompany);

        // Loop through all Serial Information records in the source company
        if SerialInfoSource.FindSet() then begin
            repeat
                if not SerialInfoTarget.Get(SerialInfoSource."No.") then begin
                    // Set the target company
                    SerialInfoTarget.CHANGECOMPANY(TargetCompany);
                    SerialInfoTarget.Init();

                    // Copy fields from source to target
                    SerialInfoTarget."No." := SerialInfoSource."No.";
                    SerialInfoTarget.Name := SerialInfoSource.Name;

                    // Insert the record into the target company
                    SerialInfoTarget.Insert(true);
                end else begin
                    SerialInfoTarget.Modify(true);
                end;
            until SerialInfoSource.Next() = 0;
        end else begin
            Error('No data found in the source company.');
        end;
    end;



    procedure TransferSerialInformationData()
    var
        CompanyRecord: Record Company;
        SourceCompany: Code[50];
        TargetCompany: Code[50];
        SelectedSourceCompany: Record Company;
        SelectedTargetCompany: Record Company;
    begin
        // Ask the user to select the Source Company
        if PAGE.RunModal(50010, SelectedSourceCompany) = ACTION::LookupOK then begin
            SourceCompany := SelectedSourceCompany.Name;
        end else
            Error('No source company selected.');

        // Ask the user to select the Target Company
        if PAGE.RunModal(50010, SelectedTargetCompany) = ACTION::LookupOK then begin
            TargetCompany := SelectedTargetCompany.Name;
        end else
            Error('No target company selected.');

        // Proceed with the data transfer
        TransferSerialInformationData(SourceCompany, TargetCompany);
        Message('Data transfer from %1 to %2 completed successfully.', SourceCompany, TargetCompany);
    end;

    procedure GetCompanyByIndex(Index: Integer): Code[50]
    var
        CompanyRecord: Record Company;
        Counter: Integer;
    begin
        Counter := 1;
        if CompanyRecord.FindSet() then begin
            repeat
                if Counter = Index then
                    exit(CompanyRecord.Name); // Return the company name at the selected index
                Counter += 1;
            until CompanyRecord.Next() = 0;
        end;
    end;
}
