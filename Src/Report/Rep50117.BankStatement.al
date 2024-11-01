report 50117 BankStatement
{
    ApplicationArea = All;
    Caption = 'Bank Statement (XKH)';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Src/LayoutReport/BankStatement.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            RequestFilterFields = "No.", "Date Filter";

            column(Balance__LCY_; "Balance (LCY)") { }
            column(Net_Change__LCY_; "Net Change (LCY)") { }
            column(ComanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(OpeningBalance; OpeningBalance2) { }
            dataitem(BankAccountLedgerEntry; "Bank Account Ledger Entry")
            {
                RequestFilterFields = "Posting Date", "Bank Account No.";
                DataItemLink = "Bank Account No." = field("No."), "Posting Date" = field("Date Filter");

                column(BankStatementFilter; BankStatementFilter)
                {
                }
                column(PostingDate; "Posting Date")
                {
                }
                column(DocumentType; "Document Type")
                {
                }
                column(DocumentNo; "Document No.")
                {
                }
                column(DebitAmountLCY; "Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY; "Credit Amount (LCY)")
                {
                }
                column(AmountLCY; "Amount (LCY)")
                {
                }
                column(CalcRunningBalance; CalRunningBalances(BankAccountLedgerEntry))
                {
                }
                column(CalBalance; CalBalance) { }
                trigger OnAfterGetRecord()
                begin
                    if BankAccountLedgerEntry.Amount > 0 then
                        OpeningBalance := BankAccountLedgerEntry.Amount;
                    OpeningBalance := OpeningBalance + BankAccountLedgerEntry.Amount;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                OpeningBalance := 0;
                if BankAccDateFilter <> '' then
                    if GetRangeMin("Date Filter") > 00000101D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change");
                        OpeningBalance := "Net Change";
                        OpeningBalance2 := OpeningBalance;
                        SetFilter("Date Filter", BankAccDateFilter);
                    end;
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        BankStatementFilter := BankAccountLedgerEntry.GetFilters;
        BankStatementFilter := "Bank Account".GetFilters;
        BankAccountLedgerEntry.SetRange("Posting Date", "Bank Account"."Date Filter");
        BankAccDateFilter := "Bank Account".GetFilter("Date Filter");
    end;

    trigger OnInitReport()
    begin
    end;

    procedure CalRunningBalances(var BankAccountLedgerEntry: Record "Bank account ledger entry"): Decimal
    begin
        CalBalance := CalcRunningBalance.GetBankAccBalance(BankAccountLedgerEntry);
    end;

    var
        BankStatementFilter: Text[60];
        BankAccDateFilter: Text[60];
        CalcRunningBalance: Codeunit "Calc. Running Acc. Balance";
        CalBalance: Decimal;
        OpeningBalance: Decimal;
        OpeningBalance2: Decimal;
}
