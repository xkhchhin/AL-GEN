report 50119 InventoryValuationCVH
{
    Caption = 'Inventory Valuation CVH';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/InventoryValuationCVH.rdl';
    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            RequestFilterFields = "Item No.", "Location Code";
            RequestFilterHeading = 'Inventory Valuation';
            column(Item_No_; "Item No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Location_Code; "Location Code") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
