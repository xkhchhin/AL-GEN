pageextension 50121 "Serial No. Information List" extends "Serial No. Information List"
{
    actions
    {
        addafter("&Item Tracing")
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

    procedure TransferSerialInformationData(SourceCompany: Code[20]; TargetCompany: Code[20])
    var
        SerialInfoSource: Record "Serial No. Information";
        SerialInfoTarget: Record "Serial No. Information";
    begin
        // Set the company to the source company
        SerialInfoSource.CHANGECOMPANY(SourceCompany);

        // Loop through all Serial Information records in the source company
        if SerialInfoSource.FindSet() then begin
            repeat
                // Clear the target record before inserting
                SerialInfoTarget.Reset();
                SerialInfoTarget.Init();

                // Copy fields from source to target
                SerialInfoTarget."Serial No." := SerialInfoSource."Serial No.";

                // Set the target company
                SerialInfoTarget.CHANGECOMPANY(TargetCompany);

                // Insert the record into the target company
                SerialInfoTarget.Insert(true);
            until SerialInfoSource.Next() = 0;
        end;
    end;



    procedure TransferSerialInformationData()
    var
        CompanyRecord: Record Company;
        CompanyNames: Text;
        CompanyOptions: Text;
        SourceCompany: Code[20];
        TargetCompany: Code[20];
        SelectedSourceIndex: Integer;
        SelectedTargetIndex: Integer;
    begin
        // Get list of all companies
        if CompanyRecord.FindSet() then begin
            repeat
                // Build options for StrMenu dialog
                CompanyNames += CompanyRecord.Name + '|';
            until CompanyRecord.Next() = 0;
        end;

        // Prompt the user to select the Source Company
        SelectedSourceIndex := StrMenu(DelChr(CompanyNames, '=', '|'), 0, 'Select Source Company');
        if SelectedSourceIndex = 0 then
            Error('No source company selected.');

        // Get the selected source company
        SourceCompany := GetCompanyByIndex(SelectedSourceIndex);

        // Prompt the user to select the Target Company
        SelectedTargetIndex := StrMenu(DelChr(CompanyNames, '=', '|'), 0, 'Select Target Company');
        if SelectedTargetIndex = 0 then
            Error('No target company selected.');

        // Get the selected target company
        TargetCompany := GetCompanyByIndex(SelectedTargetIndex);

        // Proceed with the data transfer
        TransferSerialInformationData(SourceCompany, TargetCompany);
        Message('Data transfer from %1 to %2 completed successfully.', SourceCompany, TargetCompany);
    end;

    procedure GetCompanyByIndex(Index: Integer): Code[20]
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
