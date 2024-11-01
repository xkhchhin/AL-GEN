table 50102 ScheduleList
{
    Caption = 'ScheduleList';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "Order No"; Code[20])
        {
            Caption = 'Order No';
        }
        field(3; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; Description; TableFilter)
        {
            Caption = 'Description';
        }
        field(6; "Customer No."; Code[10])
        {
            Caption = 'Customer No.';
        }
        field(7; "Customer Name"; Text[150])
        {
            Caption = 'Customer Name';
        }
        field(8; Transaction; Text[150])
        {
            Caption = 'Transaction';
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Open","Processing","Complete";
        }
        field(10; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(11; "Start Time"; Time)
        {
            Caption = 'Start Time';
        }
        field(12; "Assign To User"; Code[30])
        {
            Caption = 'Assign To User';
        }
        field(13; "Complete Date"; Date)
        {
            Caption = 'Complete Date';
        }
        field(14; "Complete Time"; Time)
        {
            Caption = 'Complete Time';
        }
        field(15; "Complete By"; Code[30])
        {
            Caption = 'Complete By';
        }
        field(16; "3D and Print"; Text[30])
        {
            Caption = '3D and Print';
        }
        field(17; "Setter Name"; Text[100])
        {
            Caption = 'Setter Name';
        }
        field(18; Reason; Text[100])
        {
            Caption = 'Reason';
        }
        field(19; Note; Text[100])
        {
            Caption = 'Note';
        }
        field(20; "Salesperson Code"; Code[50])
        {
            Caption = 'Salesperson Code';
        }
        field(21; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(22; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(23; "External Document No."; Code[50])
        {
            Caption = 'External Document No.';
        }
        field(24; "Setter Reason"; Option)
        {
            Caption = 'Setter Reason';
            OptionMembers = "Reason1","Reason2","Reason3";
        }
        field(25; "Remaining Date"; Integer)
        {
            Caption = 'Remaining Date';
        }
        field(26; Note2; Text[200])
        {
            Caption = 'Note2';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
