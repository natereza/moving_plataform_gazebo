#include <cmath>
#include <functional>
#include <string>

#include <gazebo/gazebo.hh>
#include <gazebo/physics/physics.hh>
#include <gazebo/common/common.hh>

// publisher em ROS 1
#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>

namespace gazebo
{
class MovingPlatformController : public ModelPlugin
{
public:
  void Load(physics::ModelPtr model, sdf::ElementPtr sdf) override
  {
    this->model_ = model;
    this->initial_pose_ = model->WorldPose();

    if (sdf->HasElement("axis"))
      this->axis_ = sdf->Get<std::string>("axis");

    if (sdf->HasElement("amplitude"))
      this->amplitude_ = sdf->Get<double>("amplitude");

    if (sdf->HasElement("omega"))
      this->omega_ = sdf->Get<double>("omega");

    if (sdf->HasElement("z_offset"))
      this->z_offset_ = sdf->Get<double>("z_offset");

    // Inicializa ROS, se ainda não estiver inicializado
    if (!ros::isInitialized())
    {
      int argc = 0;
      char **argv = nullptr;

      ros::init(
        argc,
        argv,
        "moving_platform_controller",
        ros::init_options::NoSigintHandler
      );
    }

    this->ros_node_ = new ros::NodeHandle("");

    this->pose_pub_ = this->ros_node_->advertise<geometry_msgs::PoseStamped>(
      "/moving_platform/pose",
      10
    );

    gzmsg << "[MovingPlatformController] Loaded for model ["
          << this->model_->GetName() << "] axis=" << this->axis_
          << " amplitude=" << this->amplitude_
          << " omega=" << this->omega_ << std::endl;

    this->update_connection_ = event::Events::ConnectWorldUpdateBegin(
      std::bind(&MovingPlatformController::OnUpdate, this, std::placeholders::_1));
  }

private:
  void OnUpdate(const common::UpdateInfo &info)
  {
    if (!this->model_)
      return;

    const double t = info.simTime.Double();
    const double displacement = this->amplitude_ * std::sin(this->omega_ * t);
    const double velocity = this->amplitude_ * this->omega_ * std::cos(this->omega_ * t);

    ignition::math::Pose3d pose = this->initial_pose_;
    ignition::math::Vector3d linear_velocity(0, 0, 0);

    if (this->axis_ == "y")
    {
      pose.Pos().Y(this->initial_pose_.Pos().Y() + displacement);
      linear_velocity.Y(velocity);
    }
    else if (this->axis_ == "z")
    {
      pose.Pos().Z(this->initial_pose_.Pos().Z() + displacement + this->z_offset_);
      linear_velocity.Z(velocity);
    }
    else
    {
      pose.Pos().X(this->initial_pose_.Pos().X() + displacement);
      linear_velocity.X(velocity);
      pose.Pos().Z(this->initial_pose_.Pos().Z() + this->z_offset_);
    }

    this->model_->SetWorldPose(pose);
    this->model_->SetLinearVel(linear_velocity);
    this->model_->SetAngularVel(ignition::math::Vector3d(0, 0, 0));

    // publica pose da plataforma em ROS
    geometry_msgs::PoseStamped pose_msg;

    pose_msg.header.stamp = ros::Time(
      info.simTime.sec,
      info.simTime.nsec
    );

    pose_msg.header.frame_id = "world";

    pose_msg.pose.position.x = pose.Pos().X();
    pose_msg.pose.position.y = pose.Pos().Y();
    pose_msg.pose.position.z = pose.Pos().Z();

    pose_msg.pose.orientation.x = pose.Rot().X();
    pose_msg.pose.orientation.y = pose.Rot().Y();
    pose_msg.pose.orientation.z = pose.Rot().Z();
    pose_msg.pose.orientation.w = pose.Rot().W();

    this->pose_pub_.publish(pose_msg);
  }

  physics::ModelPtr model_;
  event::ConnectionPtr update_connection_;
  ignition::math::Pose3d initial_pose_;

  ros::NodeHandle *ros_node_;
  ros::Publisher pose_pub_;

  std::string axis_ = "x";
  double amplitude_ = 4.0;
  double omega_ = 0.25;
  double z_offset_ = 0.0;
};

GZ_REGISTER_MODEL_PLUGIN(MovingPlatformController)
}
