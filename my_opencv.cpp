#include <opencv2/opencv.hpp>
#include <iostream>
#include <stdio.h>

extern "C" {
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
	#include "xdo.h"
}

using namespace std;
using namespace cv;

static int l_detectAndDisplay(lua_State *L);
static int l_doClick(lua_State *L);

CascadeClassifier board_cascade;

extern "C" int luaopen_my_opencv(lua_State *L)
{
	lua_register(L, "detectAndDisplay", l_detectAndDisplay);
	lua_register(L, "doClick", l_doClick);

	return 0;
}

int l_detectAndDisplay(lua_State *L)
{
	CvCapture* capture;
	Mat frame;
	const char *cascade_file = lua_tostring(L, -1);
	const char *image_file = lua_tostring(L, -2);

	if (!board_cascade.load(cascade_file)) {
		fprintf(stderr, "Error loading cascade file %s.", cascade_file);
		return -1;
	}

	frame = imread(image_file, 1);

	int i;
	vector<Rect> boards;
	Mat frame_gray;

	cvtColor(frame, frame_gray, CV_BGR2GRAY);
	equalizeHist(frame_gray, frame_gray);

	board_cascade.detectMultiScale(frame_gray, boards, 1.6, 20, 0, Size(200, 200), Size(400, 400));

	lua_newtable(L);
	for(i=0; i<boards.size(); i++) {
		Point center(boards[i].x + boards[i].width/2, boards[i].y+boards[i].height/2);
		ellipse(frame, center, Size(boards[i].width/2, boards[i].height/2), 0, 0, 360, Scalar(255, 0, 0), 2, 8, 0);
		printf("Width: %d height: %d x: %d y: %d\n", boards[i].width, boards[i].height, boards[i].x, boards[i].y);;

		lua_pushnumber(L, i+1);
		lua_newtable(L);
		lua_pushnumber(L, 1);
		lua_pushnumber(L, center.x);
		lua_settable(L, -3);
		lua_pushnumber(L, 2);
		lua_pushnumber(L, center.y);
		lua_settable(L, -3);
		lua_settable(L, -3);
	}

//	imshow("Board detection", frame);

//	waitKey(0);

	return 1;
}

int l_doClick(lua_State *L)
{
	int x = lua_tonumber(L, -2);
	int y = lua_tonumber(L, -1);

	xdo_t *xdo = xdo_new(":0");
	xdo_move_mouse(xdo, x, y, 0);
	xdo_mouse_down(xdo, CURRENTWINDOW, 1);
	xdo_mouse_up(xdo, CURRENTWINDOW, 1);
	xdo_free(xdo);

	return 0;
}
