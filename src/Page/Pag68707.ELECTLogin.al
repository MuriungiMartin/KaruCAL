#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68707 "ELECT Login"
{
    PageType = Card;

    layout
    {
        area(content)
        {
            field(Msg;Msg)
            {
                ApplicationArea = Basic;
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field(ElectionCode;ElectionCode)
            {
                ApplicationArea = Basic;
                Caption = 'Elections:';
                TableRelation = "ELECT Election".Code where ("Open Election"=const(Yes));
            }
            field(RegistrationNo;RegistrationNo)
            {
                ApplicationArea = Basic;
                Caption = 'Registration No.';
            }
            field(Password;Password)
            {
                ApplicationArea = Basic;
                Caption = 'Password:';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Enter")
            {
                ApplicationArea = Basic;
                Caption = '&Enter';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Checkif the student exists first*/
                    Student.Reset;
                    Student.SetRange(Student."Customer Type",Student."customer type"::Student);
                    Student.SetRange(Student."No.",RegistrationNo);
                    if Student.Find('-') then
                      begin
                        if Student.Password<>'' then
                          begin
                             Msg:='Invalid Password Entered.';
                             Error('Invalid Password Entered');
                          end
                        else
                          begin
                            /*Check if the voting record already exists*/
                            Header.Reset;
                            Header.SetRange(Header.Election,ElectionCode);
                            Header.SetRange(Header."Student No.",RegistrationNo);
                            Header.SetRange(Header."PIN No.",Password);
                            if Header.Find('-') then
                              begin
                              end
                            else
                              begin
                                Header.Init;
                                  Header.Election:=ElectionCode;
                                  Header."Student No.":=RegistrationNo;
                                  Header."PIN No.":=Password;
                                  Header.Date:=Today;
                                  Header.Time:=Time;
                                Header.Insert;
                              end;
                            /*Set the range of the records*/
                            Header.Reset;
                            Header.SetRange(Header.Election,ElectionCode);
                            Header.SetRange(Header."Student No.",RegistrationNo);
                            Header.SetRange(Header."PIN No.",Password);
                            if Header.Find('-') then
                              begin
                                Header.Validate(Header.Election);
                                Page.Run(39006148,Header);
                              end;
                          end;
                      end
                    else
                      begin
                        Msg:='Sorry not recognized as a valid voter';
                        Error('Sorry not recognized as a valid voter');
                      end;

                end;
            }
            action("&Cancel")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ElectionCode:='';
                    RegistrationNo:='';
                    Password:='';
                    RePassword:='';
                    Msg:='';
                end;
            }
        }
    }

    var
        ElectionCode: Code[20];
        RegistrationNo: Code[20];
        Password: Text[30];
        RePassword: Text[30];
        Msg: Text[100];
        Student: Record Customer;
        Header: Record UnknownRecord61463;
        Line: Record UnknownRecord61464;
}

