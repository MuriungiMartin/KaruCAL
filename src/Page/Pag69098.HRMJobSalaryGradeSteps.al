#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69098 "HRM-Job_Salary Grade/Steps"
{
    Caption = 'Salary Grades';
    DataCaptionFields = "Employee Category","Salary Grade code","Grade Level";
    PageType = List;
    SourceTable = UnknownTable61790;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salary Grade code";"Salary Grade code")
                {
                    ApplicationArea = Basic;
                }
                field("Grade Description";"Grade Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Grade Level";"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field("House Allowance";"House Allowance")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Allowance";"Leave Allowance")
                {
                    ApplicationArea = Basic;
                }
                field("In-Patient Medical Ceilling";"In-Patient Medical Ceilling")
                {
                    ApplicationArea = Basic;
                }
                field("Annual Leave Days";"Annual Leave Days")
                {
                    ApplicationArea = Basic;
                    Caption = 'Entitiled Leave Days';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Salsteps)
            {
                ApplicationArea = Basic;
                Caption = 'Salary Steps';
                Image = Suggest;
                Promoted = true;
                RunObject = Page "HRM-Auto_Inreament Sal. Steps";
                RunPageLink = "Employee Category"=field("Employee Category"),
                              "Salary Grade"=field("Salary Grade code");
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Imcreament';
                action(Increaments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Increment for Current Cat.';
                    Image = "Action";
                    Promoted = true;

                    trigger OnAction()
                    begin

                          if (("Employee Category"='') or ("Salary Grade code"='')) then
                          Error('Specify the Salary category and Grade first');

                           if checkMonthValidity=false then
                            Error('You can not carry out this process in this month.');

                        if Confirm('Run Salary increment for '+"Employee Category"+' ('+"Salary Grade code"+')?',false)=false then exit;

                          employees.Reset;
                          employees.SetRange(employees."Salary Category","Employee Category");
                         // employees.SETFILTER(employees."No.",'%1|%2','0093','0097');
                          if employees.Find('-') then begin    //1
                           repeat
                            begin //2
                            empSalaryCard.Reset;
                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                            if empSalaryCard.Find('-') then begin//5
                             end; //5
                             Clear(EmplMonth);
                             EmplMonth:=Date2dmy(employees."Date Of Join",2);
                             // increment for January
                             if Date2dmy(Today,2)=1 then begin //4
                              // Increase salary fro guys who were employed between January and July
                                if EmplMonth in [1..6] then begin  //38
                                  // Check whether the employee is eligible for the increment
                                    if ((Date2dmy(Today,3)) > (Date2dmy(employees."Date Of Join",3))) then begin  //37

                                         salaStepsAmount.Reset;
                                         salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                         salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",employees."Salary Grade");
                                         salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                         if salaStepsAmount.Find('-') then begin //35

                        // Basic Payfound Hence Move to the next level in the steps table
                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",employees."Salary Grade");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                  //                     empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19
                                               end;

                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////

                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////
                                         end // 33
                                         else begin  //34
                                          // Insert into Failed List
                                         end;  //34


                                            end;   //11

                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

                                         end //35
                                         else begin  //36
                                                   //77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
                                         // if employee gets salary outside of their grade...
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+1);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log  tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52



                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52

                                         end;//36   salary outside scale & grade

                                    end//37  the employee is atleast 6 Months old hence eligeable for increase
                                    else begin
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='The Employee is not six months old on employment...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16
                                                 end; // Insert into unaffected coz the employee is not more than six months old......

                                end; //38
                             end //4
                             else if Date2dmy(Today,2)=7 then begin  //3

                              // Increase salary fro guys who were employed between January and July
                                if EmplMonth in [7..12] then begin  //38
                                  // Check whether the employee is eligible for the increment
                                    if ((Date2dmy(Today,3)) > (Date2dmy(employees."Date Of Join",3))) then begin  //37

                                         salaStepsAmount.Reset;
                                         salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                         salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",employees."Salary Grade");
                                         salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                         if salaStepsAmount.Find('-') then begin //35

                        // Basic Payfound Hence Move to the next level in the steps table
                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",employees."Salary Grade");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                  //                     empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19
                                               end;

                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////

                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////
                                         end // 33
                                         else begin  //34
                                          // Insert into Failed List
                                         end;  //34


                                            end;   //11

                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

                                         end //35
                                         else begin  //36
                                                   //77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
                                         // if employee gets salary outside of their grade...
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+1);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log  tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52



                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52

                                         end;//36   salary outside scale & grade

                                    end//37  the employee is atleast 6 Months old hence eligeable for increase
                                    else begin
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 if (Date2dmy(Today,2))=1 then
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January')
                                                 else if   (Date2dmy(Today,2))=7 then
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                  if (Date2dmy(Today,2))=1 then
                                                  unaffectedEmployees."Increament Month":='January'
                                                  else if   (Date2dmy(Today,2))=7 then
                                                  unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='The Employee is not six months old on employment...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16
                                                 end; // Insert into unaffected coz the employee is not more than six months old......

                                end; //38

                             end; //3
                            end;  //2
                           until employees.Next=0;
                          end;  //1
                         // employees.setrange()
                    end;
                }
                action(IncreamentAll)
                {
                    ApplicationArea = Basic;
                    Caption = 'Increament for All Categories And Stages';
                    Image = AddAction;
                    Promoted = true;

                    trigger OnAction()
                    begin

                         // IF (("Employee Category"='') OR ("Salary Grade code"='')) THEN
                         // ERROR('Specify the Salary category and Grade first');

                           if checkMonthValidity=false then
                            Error('You can not carry out this process in this month.');

                        if Confirm('Run Salary increment for all Categories and Employees?',false)=false then exit;

                        empcat.Reset;
                        if empcat.Find('-') then begin//73
                        repeat
                        begin //72

                        empgrade.Reset;
                        empgrade.SetRange(empgrade."Employee Category",empcat.Code);
                        if empgrade.Find('-') then begin//71
                        repeat
                        begin//70
                          employees.Reset;
                          employees.SetRange(employees."Salary Category",empgrade."Employee Category");
                           employees.SetRange(employees."Salary Grade",empgrade."Salary Grade code");
                         // employees.SETFILTER(employees."No.",'%1|%2','0093','0097');
                          if employees.Find('-') then begin    //1
                           repeat
                            begin //2
                            empSalaryCard.Reset;
                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                            if empSalaryCard.Find('-') then begin//5
                             end; //5
                             Clear(EmplMonth);
                             EmplMonth:=Date2dmy(employees."Date Of Join",2);
                             // increment for January
                             if Date2dmy(Today,2)=1 then begin //4
                              // Increase salary fro guys who were employed between January and July
                                if EmplMonth in [1..6] then begin  //38
                                  // Check whether the employee is eligible for the increment
                                    if ((Date2dmy(Today,3)) > (Date2dmy(employees."Date Of Join",3))) then begin  //37

                                         salaStepsAmount.Reset;
                                         salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                         salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",employees."Salary Grade");
                                         salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                         if salaStepsAmount.Find('-') then begin //35

                        // Basic Payfound Hence Move to the next level in the steps table
                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",employees."Salary Grade");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                  //                     empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19
                                               end;

                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////

                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////
                                         end // 33
                                         else begin  //34
                                          // Insert into Failed List
                                         end;  //34


                                            end;   //11

                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

                                         end //35
                                         else begin  //36
                                                   //77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
                                         // if employee gets salary outside of their grade...
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+1);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log  tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52



                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'January');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='January';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52

                                         end;//36   salary outside scale & grade

                                    end//37  the employee is atleast 6 Months old hence eligeable for increase
                                    else begin
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='January';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='The Employee is not six months old on employment...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16
                                                 end; // Insert into unaffected coz the employee is not more than six months old......

                                end; //38
                             end //4
                             else if Date2dmy(Today,2)=7 then begin  //3

                              // Increase salary fro guys who were employed between January and July
                                if EmplMonth in [7..12] then begin  //38
                                  // Check whether the employee is eligible for the increment
                                    if ((Date2dmy(Today,3)) > (Date2dmy(employees."Date Of Join",3))) then begin  //37

                                         salaStepsAmount.Reset;
                                         salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                         salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",employees."Salary Grade");
                                         salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                         if salaStepsAmount.Find('-') then begin //35

                        // Basic Payfound Hence Move to the next level in the steps table
                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",employees."Salary Grade");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin //33
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14
                                Clear(salcat);
                                Clear(salgrade);
                                Clear(salbasic);
                        salcat:=employees."Salary Category";
                        salgrade:=salGrades2."Salary Grade code";
                        salbasic:=empSalaryCard."Basic Pay";

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                 //                      empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                                  //                     empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19
                                               end;

                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////

                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////
                                         end // 33
                                         else begin  //34
                                          // Insert into Failed List
                                         end;  //34


                                            end;   //11

                                      //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

                                         end //35
                                         else begin  //36
                                                   //77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
                                         // if employee gets salary outside of their grade...
                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+1);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log  tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

                                         salGrades.Reset;
                                         salGrades.SetRange(salGrades."Employee Category",employees."Salary Category");
                                         salGrades.SetRange(salGrades."Salary Grade code",employees."Salary Grade");
                                         if salGrades.Find('-') then begin  //52
                                         //////////////////////////////////////////////////////////////////////////////////////////
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                       //  salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin//23
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                            salaStepsAmount.SetRange(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                             //                          empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11


                        ////
                        /////////////// increment But add 2
                        /////








                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52



                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                                            end //23
                                             else begin  //42
                                              // check in the next scale again
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+2);
                                            if salGrades2.Find('-') then begin //22
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                           // salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //22
                                         else begin  //41                                                                                  //nnn
                                         salGrades2.Reset;
                                         salGrades2.SetRange(salGrades2."Employee Category",employees."Salary Category");
                                        // salGrades2.setrange(salGrades2."Salary Grade code",employees."Salary Grade");
                                         salGrades2.SetRange(salGrades2."Grade Level",salGrades."Grade Level"+3);
                                            if salGrades2.Find('-') then begin //21
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            // Change Basic pay and insert into the register
                                            // Find the value of new salary from the steps.
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //14
                                            end;//14

                                            salaStepsAmount.Reset;
                                            salaStepsAmount.SetRange(salaStepsAmount."Employee Category",employees."Salary Category");
                                          //  salaStepsAmount.SETRANGE(salaStepsAmount."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount.SetRange(salaStepsAmount."Basic Salary",empSalaryCard."Basic Pay");
                                            if salaStepsAmount.Find('-') then begin  //13
                                            // select the new employee salary and
                                            // Update Basic Pay here
                                            salaStepsAmount2.Reset;
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Employee Category",employees."Salary Category");
                                            salaStepsAmount2.SetRange(salaStepsAmount2."Salary Grade",salGrades2."Salary Grade code");
                                            salaStepsAmount2.SetRange(salaStepsAmount2.Step,(salaStepsAmount.Step+1));
                                            if salaStepsAmount2.Find('-') then begin   // 10
                                            // At last! Insert into the Log and
                                                if salaStepsAmount2."Basic Salary">0 then begin  // 7
                                                       salincregister.Reset;
                                                       salincregister.SetRange(salincregister."Employee No.",employees."No.");
                                                       salincregister.SetRange(salincregister."Increament Month",'July');
                                                       salincregister.SetRange(salincregister."Increament Year",(Date2dmy(Today,3)));
                                                       if not salincregister.Find('-') then begin // 6
                                                       // insert into the register
                                                         salincregister.Init;
                                                         salincregister."Employee No.":=employees."No.";
                                                         salincregister."Increament Month":='July';
                                                         salincregister."Increament Year":=(Date2dmy(Today,3));
                                                         salincregister."User ID":=UserId;
                                                         salincregister."Prev. Salary" :=empSalaryCard."Basic Pay";
                                                         salincregister."Current Salary":=salaStepsAmount2."Basic Salary";
                                                         salincregister."Job Grade":=employees."Salary Grade";
                                                         salincregister."Job Category":=employees."Salary Category";
                                                         salincregister.Insert;
                                                       // Update Basic
                                                       empSalaryCard."Basic Pay":=salaStepsAmount2."Basic Salary";
                              //                         empSalaryCard.MODIFY;
                                                       end; // 6
                                                end // 7
                                                 else begin  // 8
                                                //the salary in the steps is zero hence cannot insert
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //9
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='salary in the steps is zero hence cannot insert.....';
                                                 unaffectedEmployees.Insert;
                                                 end;   //9

                                                end;  // 8
                                            end  // 10
                                             else begin  //11
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin//12
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //12

                                            end;   //11


                                              // empSalaryCard."Basic Pay":=;
                                            end  //13
                                             else begin //17
                                            // Dint update hence log
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16

                                            end; //17

                                            empSalaryCard.Reset;
                                            empSalaryCard.SetRange(empSalaryCard."Employee Code",employees."No.");
                                            if empSalaryCard.Find('-') then begin //18
                                              // Change Basic Pay
                                             // empSalaryCard."Basic Pay":=;
                                            end; //18
                                            //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                            end //21
                                             else begin //20
                                              //error into logs - No more salary steps found
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin  //19

                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                 unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='There are no more salary Steps...';
                                                 unaffectedEmployees.Insert;

                                                 end;   //19


                                            end;   //20
                                            end; //41
                                           end; //42
                                         ////////////////////////////////////////////////////////////////////////////////////////////


                                         end;//52

                                         end;//36   salary outside scale & grade

                                    end//37  the employee is atleast 6 Months old hence eligeable for increase
                                    else begin
                                                 unaffectedEmployees.Reset;
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Employee No.",employees."No.");
                                                 if (Date2dmy(Today,2))=1 then
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'January')
                                                 else if   (Date2dmy(Today,2))=7 then
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Month",'July');
                                                 unaffectedEmployees.SetRange(unaffectedEmployees."Increament Year",(Date2dmy(Today,3)));
                                                 if not unaffectedEmployees.Find('-') then begin //16
                                                 // insert into the unaffectedEmployees table
                                                 unaffectedEmployees.Init;
                                                 unaffectedEmployees."Employee No.":=employees."No.";
                                                  if (Date2dmy(Today,2))=1 then
                                                  unaffectedEmployees."Increament Month":='January'
                                                  else if   (Date2dmy(Today,2))=7 then
                                                  unaffectedEmployees."Increament Month":='July';
                                                 unaffectedEmployees."Increament Year":=(Date2dmy(Today,3));
                                                 unaffectedEmployees."Employee Category":=employees."Salary Category";
                                                 unaffectedEmployees."Employee Grade":=employees."Salary Grade";
                                                 unaffectedEmployees.Reason :='The Employee is not six months old on employment...';
                                                 unaffectedEmployees.Insert;
                                                 end; //16
                                                 end; // Insert into unaffected coz the employee is not more than six months old......

                                end; //38

                             end; //3
                            end;  //2
                           until employees.Next=0;
                          end;  //1
                         // employees.setrange()

                        end; //70
                        until empgrade.Next=0;
                        end;//71
                        end;//72
                        until empcat.Next=0;
                        end;//73
                    end;
                }
                separator(Action17)
                {
                    Caption = 'History';
                }
                action("Increament Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Increament Register';
                    Image = Registered;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action("Un-Affected Employees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Un-Affected Employees';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HRM-Unaffected Sal. Increament";
                }
                separator(Action14)
                {
                }
                action(PostIncreament)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Salary Inrements';
                    Image = PostDocument;
                    Promoted = true;

                    trigger OnAction()
                    begin

                         Message('Please go through the Increment register \and ensure that the increments are right before posting.');
                          if Confirm('Are you sure you want to post salary increments?',false)=false then exit;
                         postReverse.postRegister();
                    end;
                }
                action(ReverseIncreament)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reverse Salary Increments';
                    Image = ReverseRegister;
                    Promoted = true;

                    trigger OnAction()
                    begin

                          if Confirm('Reverse salary Increment postings?',false)=false then exit;
                        postReverse.ReverseInrementPosting();
                    end;
                }
            }
        }
    }

    var
        salGrades: Record UnknownRecord61790;
        salGrades2: Record UnknownRecord61790;
        salincregister: Record UnknownRecord61791;
        salincUnaffected: Record UnknownRecord61792;
        employees: Record UnknownRecord61118;
        salaryCate: Record UnknownRecord61789;
        EmplMonth: Integer;
        salaStepsAmount: Record UnknownRecord61793;
        salaStepsAmount2: Record UnknownRecord61793;
        empSalaryCard: Record UnknownRecord61105;
        unaffectedEmployees: Record UnknownRecord61792;
        salbasic: Decimal;
        salgrade: Code[20];
        salcat: Code[50];
        empcat: Record UnknownRecord61789;
        empgrade: Record UnknownRecord61790;
        postReverse: Codeunit "Post Salary Increments";


    procedure checkMonthValidity() validity: Boolean
    var
        salarystepsmanager: Record UnknownRecord61794;
    begin
         validity:=false;
         if ((Date2dmy(Today,2)<>1) and (Date2dmy(Today,2)<>7)) then
           validity:=false else  validity:=true;
    end;
}

