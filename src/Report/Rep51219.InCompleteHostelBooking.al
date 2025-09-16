#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51219 "InComplete Hostel Booking"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InComplete Hostel Booking.rdlc';

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            DataItemTableView = sorting("Hostel No") where(Billed=const(false),Cleared=const(false));
            RequestFilterFields = "Hostel No",Semester,"Space No",Student;
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
            column(Students_Hostel_Rooms__Hostel_No_;"Hostel No")
            {
            }
            column(Students_Hostel_Rooms__Hostel_Name_;"Hostel Name")
            {
            }
            column(Students_Hostel_Rooms__Space_No_;"Space No")
            {
            }
            column(Students_Hostel_Rooms__Room_No_;"Room No")
            {
            }
            column(Students_Hostel_Rooms__Hostel_No__Control1000000017;"Hostel No")
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee_;"Accomodation Fee")
            {
            }
            column(Students_Hostel_Rooms_Student;Student)
            {
            }
            column(CustName;CustName)
            {
            }
            column(SCount;SCount)
            {
            }
            column(Students_Hostel_Rooms__Students_Hostel_Rooms___Allocation_Date_;"ACA-Students Hostel Rooms"."Allocation Date")
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee__Control1000000022;"Accomodation Fee")
            {
            }
            column(TCount;TCount)
            {
            }
            column(Students_Hostel_RoomsCaption;Students_Hostel_RoomsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Students_Hostel_Rooms__Space_No_Caption;FieldCaption("Space No"))
            {
            }
            column(Students_Hostel_Rooms__Room_No_Caption;FieldCaption("Room No"))
            {
            }
            column(Students_Hostel_Rooms__Hostel_No__Control1000000017Caption;FieldCaption("Hostel No"))
            {
            }
            column(Students_Hostel_Rooms__Accomodation_Fee_Caption;FieldCaption("Accomodation Fee"))
            {
            }
            column(Students_Hostel_Rooms_StudentCaption;FieldCaption(Student))
            {
            }
            column(Student_NameCaption;Student_NameCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Allocation_DateCaption;Allocation_DateCaptionLbl)
            {
            }
            column(Students_Hostel_Rooms__Hostel_No_Caption;FieldCaption("Hostel No"))
            {
            }
            column(Total_AccomodationCaption;Total_AccomodationCaptionLbl)
            {
            }
            column(Total_StudentsCaption;Total_StudentsCaptionLbl)
            {
            }
            column(Students_Hostel_Rooms_Line_No;"Line No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                   if Cust.Get("ACA-Students Hostel Rooms".Student) then
                   CustName:=Cust.Name;
                   SCount:=SCount+1;
                   TCount:=TCount+1;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Hostel No");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        Cust: Record Customer;
        CustName: Text[100];
        SCount: Integer;
        TCount: Integer;
        Students_Hostel_RoomsCaptionLbl: label 'Students Hostel Rooms';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_NameCaptionLbl: label 'Student Name';
        EmptyStringCaptionLbl: label '#';
        Allocation_DateCaptionLbl: label 'Allocation Date';
        Total_AccomodationCaptionLbl: label 'Total Accomodation';
        Total_StudentsCaptionLbl: label 'Total Students';
}

