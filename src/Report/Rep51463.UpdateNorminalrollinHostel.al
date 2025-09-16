#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51463 "Update Norminal roll in Hostel"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Norminal roll in Hostel.rdlc';

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            DataItemTableView = sorting("Line No",Student);
            RequestFilterFields = Billed;
            column(ReportForNavId_4756; 4756)
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
            column(Students_Hostel_Rooms__Line_No_;"Line No")
            {
            }
            column(Students_Hostel_Rooms__Space_No_;"Space No")
            {
            }
            column(Students_Hostel_Rooms__Room_No_;"Room No")
            {
            }
            column(Students_Hostel_Rooms__Hostel_No_;"Hostel No")
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee_;"Accomodation Fee")
            {
            }
            column(Students_Hostel_RoomsCaption;Students_Hostel_RoomsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Students_Hostel_Rooms__Line_No_Caption;FieldCaption("Line No"))
            {
            }
            column(Students_Hostel_Rooms__Space_No_Caption;FieldCaption("Space No"))
            {
            }
            column(Students_Hostel_Rooms__Room_No_Caption;FieldCaption("Room No"))
            {
            }
            column(Students_Hostel_Rooms__Hostel_No_Caption;FieldCaption("Hostel No"))
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee_Caption;FieldCaption("Accomodation Fee"))
            {
            }
            column(Students_Hostel_Rooms_Student;Student)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   Creg.Reset;
                   Creg.SetRange(Creg."Student No.","ACA-Students Hostel Rooms".Student);
                   Creg.SetRange(Creg.Semester,"ACA-Students Hostel Rooms".Semester);
                   if Creg.Find('-') then begin
                   Creg.Registered:=true;
                   Creg.Modify;
                   end;
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
        Creg: Record UnknownRecord61532;
        Students_Hostel_RoomsCaptionLbl: label 'Students Hostel Rooms';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

