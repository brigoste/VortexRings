import Plots
using Plots
using LinearAlgebra

function displacement_Finder(p1, p2)
    #Finds scalar distance between 2 vortecies

    disp_Vec = p2 - p1

    #Return magnitude of resultant vector
    disp = sqrt(disp_Vec[1]^2 + disp_Vec[2]^2 + disp_Vec[3]^2)

    #In this function we want a scalar as a scalar is necessary for the Velocity Calculation.
    return disp
end

function velocity_Calculation(Gamma, r, r_mag)
    #V = (Gamma x r) / (2*pi*r_mag)
    #Cross product function, included in LinearAlgebra
    num = cross(Gamma, r)
    denom = 2*pi*(r_mag^2)
    Vel = num/denom
    #We return a vector as it keeps the direction.
    return Vel
end

function main()
    gamma_Test = [0;0;1];   #Circulation vector
    d_Test = 1.0;           #Initial distance between vortecies
    dt = 0.01;              #time step change

    #Arrays holding the positions of the vortexes over time, initialized to 0.
    #These hold the x,y, and z positions.
    pos1 = zeros(4000, 3)
    pos2 = zeros(4000, 3)
    pos3 = zeros(4000, 3)
    pos4 = zeros(4000, 3)
    t = zeros(4000)

    #Initial Vortex positions, named bottom-left moving clockwise
    p1 = [0; -d_Test/2; 0]
    p2 = [0; d_Test/2; 0]
    p3 = [1; d_Test/2; 0]
    p4 = [1; -d_Test/2; 0]
    #I want this info from every iteration
    v1 = zeros(4000,3)
    v2 = zeros(4000,3)
    v3 = zeros(4000,3)
    v4 = zeros(4000,3)



    for x = 1:4000
        # inititial velocities of the 4 vortex centers (v_x, v_y, v_z)
        # The Velocity vecotr is set to 0 at the start of the code.

        #adds values to the time array, used to plot
        t[x] = (x-1)*dt
        #ex. for the first iteration, x = 1,t[1] = 0

        #adds new position to the array
        pos1[x,:] = p1
        pos2[x,:] = p2
        pos3[x,:] = p3
        pos4[x,:] = p4

        #Vectors between Vortecies, vector r in functions
        p1_2 = p2-p1
        p1_3 = p3-p1
        p1_4 = p4-p1
        p2_1 = p1-p2
        p2_3 = p3-p2
        p2_4 = p4-p2
        p3_1 = p1-p3
        p3_2 = p2-p3
        p3_4 = p4-p3
        p4_1 = p1-p4
        p4_2 = p2-p4
        p4_3 = p3-p4

        #Distance between each vortex, named r_mag in functions
        d1_2 = displacement_Finder(p1, p2)
        d1_3 = displacement_Finder(p1, p3)
        d1_4 = displacement_Finder(p1, p4)
        d2_3 = displacement_Finder(p2, p3)
        d2_4 = displacement_Finder(p2, p4)
        d3_4 = displacement_Finder(p3, p4)

        #Calculating The Velocity Changes imposed by each other vortex
        #These give vector results
        #The influence vector is the sum of all velocities on the vortex
        v1_2 = velocity_Calculation(-gamma_Test, p1_2, d1_2)
        v1_3 = velocity_Calculation(-gamma_Test, p1_3, d1_3)
        v1_4 = velocity_Calculation(gamma_Test, p1_4, d1_4)
        v1_Influence = v1_2 + v1_3 + v1_4   #[v_x, v_y, v_z]
        v1[x,:] = v1_Influence

        v2_1 = velocity_Calculation(gamma_Test, p2_1, d1_2)
        v2_3 = velocity_Calculation(-gamma_Test, p2_3, d2_3)
        v2_4 = velocity_Calculation(gamma_Test, p2_4, d2_4)
        v2_Influence = v2_1 + v2_3 + v2_4
        v2[x,:] = v2_Influence

        #Tequnically, v3 will be moved the same as v4, and v1 the same as v2,
        #   so do I need all of these differenct calulations
        v3_1 = velocity_Calculation(gamma_Test, p3_1, d1_3)
        v3_2 = velocity_Calculation(-gamma_Test, p3_2, d2_3)
        v3_4 = velocity_Calculation(gamma_Test, p3_4, d3_4)
        v3_Influence = v3_1 + v3_2 + v3_4
        v3[x,:] = v3_Influence

        v4_1 = velocity_Calculation(gamma_Test, p4_1, d1_4)
        v4_2 = velocity_Calculation(-gamma_Test, p4_2, d2_4)
        v4_3 = velocity_Calculation(-gamma_Test, p4_3, d3_4)
        v4_Influence = v4_1 + v4_2 + v4_3
        v4[x,:] = v4_Influence

        #Update position of the vortecies using a linear approximation of their influenced velocities.
        p1 = p1 + (v1_Influence * dt)
        p2 = p2 + (v2_Influence * dt)
        p3 = p3 + (v3_Influence * dt)
        p4 = p4 + (v4_Influence * dt)

    end


    println("x  p1  p2  p3  p4")    #Output of values to check

    #This plots the x v. y data of the vortecies
    plot(pos1[:,1], pos1[:,2], title = "Vortices' Movement", label = "Vortex 1", legend=:right, color = :red)    #using Plots
    plot!(pos2[:,1], pos2[:,2], label = "Vortex 2", color = :red)
    plot!(pos3[:,1], pos3[:,2], label = "Vortex 3", color = :blue)
    plot!(pos4[:,1], pos4[:,2], label = "Vortex 4", color = :blue)
    xlabel!("X Position (m)")
    ylabel!("Y Position (m)")

    #This plots the t v. y data of the vortecies
    # plot(t[:,1], pos1[:,2], title = "NEW GRAPH", label = "Vortex 1", legend = :right, ColorTypes = :blue)
    # plot!(t[:,1], pos2[:,2], label = "Vortex 2", ColorTypes = :red)
    # plot!(t[:,1], pos3[:,2], label = "Vortex 3", ColorTypes = :red)
    # plot!(t[:,1], pos4[:,2], label = "Vortex 4", ColorTypes = :blue)
    # xlabel!("Time (s)")
    # ylabel!("Y Position")
    # for x = 1:4000
    #     println(pos1[x,:])
    # end
    # plot!(t, pos2[:,1])
    # plot!(t, pos2[:,2])
    # #plot y positions
    # plot(t, pos1[:,2], "b-", t, pos2[:,2], "g-", t, pos3[:,2], "g-", t, pos4[:,2], "b-")
    # #plot z positions
    # Plots.plot(t, pos1[:,3], "b-", t, pos2[:,3], "g-", t, pos3[:,3], "g-", t, pos4[:,3], "b-")
    #
    # #Plots x v.s. y coordinates.
    # Plots.plot(pos1[:,1], pos1[:,2], "b-", pos2[:,1], pos2[:,2], "g-", pos3[:,1], pos3[:,2],"g-", pos4[:,1], pos4[:,2], "b-")

    #I want to print out the first few positions and iterations of the vortecies
end

main()
