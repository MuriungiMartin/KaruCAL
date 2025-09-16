#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51245 "Hostel Inventory"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Inventory.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Ledger";"ACA-Hostel Ledger")
        {
            DataItemTableView = sorting("Space No","Room No","Hostel No");
            RequestFilterFields = "Hostel No","Room No","Student No","Space No";
            column(ReportForNavId_3889; 3889)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Hostel_Ledger__Hostel_No_;"Hostel No")
            {
            }
            column(Hostel_Ledger__Space_No_;"Space No")
            {
            }
            column(Hostel_Ledger__Room_No_;"Room No")
            {
            }
            column(Hostel_Ledger_Status;Status)
            {
            }
            column(Hostel_Ledger__Room_Cost_;"Room Cost")
            {
            }
            column(Hostel_Ledger__Student_No_;"Student No")
            {
            }
            column(Hostel_InventoryCaption;Hostel_InventoryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Hostel_Ledger__Hostel_No_Caption;FieldCaption("Hostel No"))
            {
            }
            column(Hostel_Ledger__Space_No_Caption;FieldCaption("Space No"))
            {
            }
            column(Hostel_Ledger__Room_No_Caption;FieldCaption("Room No"))
            {
            }
            column(Hostel_Ledger_StatusCaption;FieldCaption(Status))
            {
            }
            column(Hostel_Ledger__Room_Cost_Caption;FieldCaption("Room Cost"))
            {
            }
            column(Hostel_Ledger__Student_No_Caption;FieldCaption("Student No"))
            {
            }
            dataitem(UnknownTable61164;UnknownTable61164)
            {
                DataItemLink = "Space No"=field("Space No");
                column(ReportForNavId_6356; 6356)
                {
                }
                column(Room_Inventory__Type_No_;"Type No")
                {
                }
                column(Room_Inventory_Description;Description)
                {
                }
                column(Room_Inventory_Units;Units)
                {
                }
                column(Room_Inventory_Quantity;Quantity)
                {
                }
                column(Room_Inventory__Unit_Price_;"Unit Price")
                {
                }
                column(Room_Inventory__Item_Charges_;"Item Charges")
                {
                }
                column(Room_Inventory__Type_No_Caption;FieldCaption("Type No"))
                {
                }
                column(Room_Inventory_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Room_Inventory_UnitsCaption;FieldCaption(Units))
                {
                }
                column(Room_Inventory_QuantityCaption;FieldCaption(Quantity))
                {
                }
                column(Room_Inventory__Unit_Price_Caption;FieldCaption("Unit Price"))
                {
                }
                column(Room_Inventory__Item_Charges_Caption;FieldCaption("Item Charges"))
                {
                }
                column(Room_Inventory_Line_No;"Line No")
                {
                }
                column(Room_Inventory_Space_No;"Space No")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Hostel_InventoryCaptionLbl: label 'Hostel Inventory';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

