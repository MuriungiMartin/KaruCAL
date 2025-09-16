#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51422 "Hostel Registration"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Registration.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer_Address;Address)
            {
            }
            column(Customer__Address_2_;"Address 2")
            {
            }
            column(Customer__Student_Programme_;"Student Programme")
            {
            }
            column(STUDENT_HOSTEL_REGISTRATIONCaption;STUDENT_HOSTEL_REGISTRATIONCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer_AddressCaption;FieldCaption(Address))
            {
            }
            column(Programme_Caption;Programme_CaptionLbl)
            {
            }
            dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
            {
                DataItemLink = Student=field("No.");
                column(ReportForNavId_4756; 4756)
                {
                }
                column(Students_Hostel_Rooms__Hostel_No_;"Hostel No")
                {
                }
                column(Students_Hostel_Rooms__Room_No_;"Room No")
                {
                }
                column(Students_Hostel_Rooms__Space_No_;"Space No")
                {
                }
                column(Students_Hostel_Rooms__Accomodation_Fee_;"Accomodation Fee")
                {
                }
                column(Students_Hostel_Rooms_Cleared;Cleared)
                {
                }
                column(Students_Hostel_Rooms__Hostel_No_Caption;FieldCaption("Hostel No"))
                {
                }
                column(Students_Hostel_Rooms__Room_No_Caption;FieldCaption("Room No"))
                {
                }
                column(Students_Hostel_Rooms__Space_No_Caption;FieldCaption("Space No"))
                {
                }
                column(Students_Hostel_Rooms__Accomodation_Fee_Caption;FieldCaption("Accomodation Fee"))
                {
                }
                column(Students_Hostel_Rooms_ClearedCaption;FieldCaption(Cleared))
                {
                }
                column(Students_Hostel_Rooms_Line_No;"Line No")
                {
                }
                column(Students_Hostel_Rooms_Student;Student)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                   Customer.CalcFields(Customer."Student Programme");
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
        STUDENT_HOSTEL_REGISTRATIONCaptionLbl: label 'STUDENT HOSTEL REGISTRATION';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Programme_CaptionLbl: label 'Programme ';
}

