report 50118 "Payment Voucher(CVH1)"
{
    ApplicationArea = all;
    Caption = 'Payment Voucher(CVH1)';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './LayoutReport/PaymentVoucher.rdl';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;


    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Document No.";
            RequestFilterHeading = 'Standard Purchase - Order';
            column(ComapanyInfoName; ComapanyInfo.Name)
            {
            }
            column(ComapanyInfoAddress; ComapanyInfo.Address)
            {
            }

            column(ComapanyInfoPhoneNo; ComapanyInfo."Phone No.")
            {
            }

            column(ComapanyInfoPicture; ComapanyInfo.Picture)
            {
            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Posting_Group; "Posting Group")
            {

            }
            column(Account_Type; "Account Type")
            {

            }
            column(Account_No_; "Account No.")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Bal__Account_Type; "Bal. Account Type")
            {

            }
            column(Bal__Account_No_; "Bal. Account No.")
            {

            }
            column(Amount__LCY_; "Amount (LCY)")
            {

            }
            column(Description; Description)
            {

            }
            column(Amount; Amount)
            {

            }
            column(Amount_Including_VAT__ACY_; "Amount Including VAT (ACY)")
            {

            }
            column(Currency_Code; "Currency Code")
            {

            }
        }
    }
    trigger OnInitReport()
    Begin
        ComapanyInfo.SetAutoCalcFields(Picture);
        ComapanyInfo.Get();
    End;

    var
        ComapanyInfo: Record "Company Information";
}