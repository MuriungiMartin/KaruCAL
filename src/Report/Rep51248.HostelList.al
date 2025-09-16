#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51248 "Hostel List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel List.rdlc';

    dataset
    {
        dataitem("ACA-Hostel Card";"ACA-Hostel Card")
        {
            DataItemTableView = sorting("Asset No");
            RequestFilterFields = "Asset No";
            column(ReportForNavId_7367; 7367)
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
            column(Hostel_Card__Asset_No_;"Asset No")
            {
            }
            column(Hostel_Card_Discription;Description)
            {
            }
            column(Hostel_Card__Space_Per_Room_;"Space Per Room")
            {
            }
            column(Hostel_Card_Gender;Gender)
            {
            }
            column(Hostel_Card__Total_Rooms_Created_;"Total Rooms Created")
            {
            }
            column(Hostel_Card__Total_Vacant_;"Total Vacant")
            {
            }
            column(Hostel_Card__Total_Occupied_;"Total Occupied")
            {
            }
            column(Hostel_Card__Total_Out_of_Order_;"Total Out of Order")
            {
            }
            column(Hostel_Card__Room_Prefix_;"Room Prefix")
            {
            }
            column(tOut;tOut)
            {
            }
            column(tOccupied;tOccupied)
            {
            }
            column(tVacant;tVacant)
            {
            }
            column(tAll;tAll)
            {
            }
            column(Hostel_SummaryCaption;Hostel_SummaryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Hostel_Card__Asset_No_Caption;FieldCaption("Asset No"))
            {
            }
            column(Hostel_Card_DiscriptionCaption;FieldCaption(Description))
            {
            }
            column(Hostel_Card__Space_Per_Room_Caption;FieldCaption("Space Per Room"))
            {
            }
            column(Hostel_Card_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Total_RoomsCaption;Total_RoomsCaptionLbl)
            {
            }
            column(Hostel_Card__Total_Vacant_Caption;FieldCaption("Total Vacant"))
            {
            }
            column(Hostel_Card__Total_Occupied_Caption;FieldCaption("Total Occupied"))
            {
            }
            column(Hostel_Card__Total_Out_of_Order_Caption;FieldCaption("Total Out of Order"))
            {
            }
            column(Hostel_Card__Room_Prefix_Caption;FieldCaption("Room Prefix"))
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  tVacant:=tVacant+"ACA-Hostel Card"."Total Vacant";
                  tAll:=tAll+"ACA-Hostel Card"."Total Rooms Created";
                  tOccupied:=tOccupied+"ACA-Hostel Card"."Total Occupied";
                  tOut:=tOut+"ACA-Hostel Card"."Total Out of Order";
            end;
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
        tVacant: Integer;
        tOccupied: Integer;
        tAll: Integer;
        tOut: Integer;
        Hostel_SummaryCaptionLbl: label 'Hostel Summary';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_RoomsCaptionLbl: label 'Total Rooms';
        TotalsCaptionLbl: label 'Totals';
}

