#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51795 "Hostel Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hostel Invoice.rdlc';

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            DataItemTableView = where(Cleared=filter(false));
            column(ReportForNavId_1; 1)
            {
            }
            column(HostNo;"ACA-Students Hostel Rooms"."Hostel No")
            {
            }
            column(RoomNo;"ACA-Students Hostel Rooms"."Room No")
            {
            }
            column(SpaceNo;"ACA-Students Hostel Rooms"."Space No")
            {
            }
            column(stdNo;cust."No.")
            {
            }
            column(stdName;cust.Name)
            {
            }
            column(IDNo;cust."ID No")
            {
            }
            column(dEPTnAME;Prog."Department Name"+'('+Prog."Department Code"+')')
            {
            }
            column(ProgName;Prog.Description+'('+Prog.Code+')')
            {
            }
            column(DateGen;Today)
            {
            }
            column(address;cust.Address)
            {
            }
            column(addr2;cust."Address 2")
            {
            }
            column(email;cust."E-Mail")
            {
            }
            column(phone;cust."Phone No.")
            {
            }
            column(Bal;cust."Balance (LCY)"-"ACA-Students Hostel Rooms".Charges)
            {
            }
            column(Chargez;"ACA-Students Hostel Rooms".Charges)
            {
            }
            column(TotalCharge;cust."Balance (LCY)")
            {
            }
            column(curruser;currUser)
            {
            }
            column(FOOTER1;'PLEASE ADVICE THE HOUSEKEEPER OF ANY OMISSION OR ERRORS IN THE DETAILS OF THIS FORM, AND BRING IT WITH YOU WHEN YOU')
            {
            }
            column(fOOTER2;'PAY YOUR FEES CHARGED')
            {
            }
            column(Footer3;'THIS INVOICE IS VALID ONLY FOR 24 HOURS')
            {
            }
            column(hEADER1;'KARATINA UNIVERSITY P.O. BOX 1957 - 10101 KARATINA TEL: 05920091')
            {
            }
            column(invpost;invpost)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     Clear(invpost);
                     if "ACA-Students Hostel Rooms"."Invoice Printed" then
                     invpost:='DUPLICATE';
                       Clear(bals);
                      Clear(bal2);
                       if "ACA-Students Hostel Rooms".Allocated=false then Error('Print the Invoive only after Posting allocation.');
                       if not (cust.Get("ACA-Students Hostel Rooms".Student)) then Error('Student Missing.');
                      courseReg.Reset;
                      courseReg.SetRange(courseReg."Student No.","ACA-Students Hostel Rooms".Student);
                      courseReg.SetRange(courseReg.Semester,"ACA-Students Hostel Rooms".Semester);
                      courseReg.SetRange(courseReg."Academic Year","ACA-Students Hostel Rooms"."Academic Year");
                     if courseReg.Find('-') then begin
                      Prog.Reset;
                      Prog.SetRange(Prog.Code,courseReg.Programme);
                      if Prog.Find('-') then begin
                      Prog.CalcFields(Prog."Department Name");
                        Dept.Reset;
                       // Dept.setrange(Dept.Code,);
                      end;
                     end;
                     if cust.Get(Student) then
                     cust.CalcFields(cust."Balance (LCY)");

                 //IF Allocated=TRUE THEN bals:="Students Hostel Rooms".Balance-"Students Hostel Rooms".Charges
                // ELSE bals:="Students Hostel Rooms".Balance;
                 bal2:=cust."Balance (LCY)";//bals+"Students Hostel Rooms".Charges;

                "ACA-Students Hostel Rooms"."Invoice Printed":=true;
                Modify;
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

    trigger OnPreReport()
    begin
                Clear(currUser);
                 users.Reset;
                users.SetRange(users."User Name",UserId);
                if users.Find('-') then begin
                if users."Full Name"<>'' then currUser:=users."Full Name" else currUser:=users."User Name";
                end;
    end;

    var
        cust: Record Customer;
        courseReg: Record UnknownRecord61532;
        Prog: Record UnknownRecord61511;
        Dept: Record "Dimension Value";
        users: Record User;
        currUser: Code[150];
        Hostels: Record "ACA-Students Hostel Rooms";
        bals: Decimal;
        bal2: Decimal;
        invpost: Code[30];
}

