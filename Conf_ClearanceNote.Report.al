#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70004 "Conf_ Clearance Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Conf_ Clearance Note.rdlc';

    dataset
    {
        dataitem(UnknownTable70000;UnknownTable70000)
        {
            DataItemTableView = where(Cleared=filter(Yes));
            column(ReportForNavId_1; 1)
            {
            }
            column(HostNo;"Participants Conf_ Facilitys"."Conf_ No")
            {
            }
            column(FacilityNo;"Participants Conf_ Facilitys"."Facility No")
            {
            }
            column(SpaceNo;"Participants Conf_ Facilitys"."Space No")
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
            column(Bal;cust."Balance (LCY)"-"Participants Conf_ Facilitys".Charges)
            {
            }
            column(Chargez;"Participants Conf_ Facilitys".Charges)
            {
            }
            column(TotalCharge;cust."Balance (LCY)")
            {
            }
            column(curruser;currUser)
            {
            }
            column(FOOTER1;'PLEASE USE THIS CLEARANCE NOTE AT THE GATE')
            {
            }
            column(fOOTER2;'')
            {
            }
            column(Footer3;'THIS CLEARANCE NOTE IS VALID FOR 24 HOURS')
            {
            }
            column(hEADER1;'KENYA SCHOOL OF GOVERNMENT P.O. BOX 15653 - 00503 NAIROBI TEL: +254-020-2071391')
            {
            }
            column(invpost;invpost)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     Clear(invpost);
                     if "Participants Conf_ Facilitys"."Invoice Printed" then
                     invpost:='DUPLICATE';
                       Clear(bals);
                      Clear(bal2);
                       if "Participants Conf_ Facilitys".Allocated=false then Error('Print the Invoive only after Posting allocation.');
                       if not (cust.Get("Participants Conf_ Facilitys".Participant)) then Error('Participant Missing.');
                      courseReg.Reset;
                      courseReg.SetRange(courseReg."Participant No.","Participants Conf_ Facilitys".Participant);
                      courseReg.SetRange(courseReg.Semester,"Participants Conf_ Facilitys".Semester);
                      courseReg.SetRange(courseReg."Academic Year","Participants Conf_ Facilitys"."Academic Year");
                     if courseReg.Find('-') then begin
                      Prog.Reset;
                      Prog.SetRange(Prog.Code,courseReg.Programme);
                      if Prog.Find('-') then begin
                      Prog.CalcFields(Prog."Department Name");
                        Dept.Reset;
                       // Dept.setrange(Dept.Code,);
                      end;
                     end;
                     if cust.Get(Participant) then
                     cust.CalcFields(cust."Balance (LCY)");
                  if currUser='' then  currUser:=UserId;

                 //IF Allocated=TRUE THEN bals:="Participants Conf_ Facilitys".Balance-"Participants Conf_ Facilitys".Charges
                // ELSE bals:="Participants Conf_ Facilitys".Balance;
                 bal2:=cust."Balance (LCY)";//bals+"Participants Conf_ Facilitys".Charges;

                "Participants Conf_ Facilitys"."Invoice Printed":=true;
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
        courseReg: Record UnknownRecord39006015;
        Prog: Record UnknownRecord39005994;
        Dept: Record "Dimension Value";
        users: Record User;
        currUser: Code[150];
        Conf_s: Record UnknownRecord70000;
        bals: Decimal;
        bal2: Decimal;
        invpost: Code[30];
}

