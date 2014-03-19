using UnityEngine;
using System.Collections;

public class CameralMove : MonoBehaviour {
	public float cameraMoveSpeed = 0.3f;
	// Use this for initialization
	void Start () {
		transform.position = new Vector3 (1, 0, -3);
	}
	int direction = 1;
	int lastVisited = 0;
	// Update is called once per frame
	void Update () {
		Vector3 cameraPos = Camera.main.transform.position;
		float x = cameraPos.x;

		if (x > 22) {
			direction = -1;
			lastVisited = 1;
		} else if (x > 1 && x <= 22) {
			direction = (lastVisited == 1) ? -1 : 1;
		} else {
			lastVisited = 0;
			direction = 1;
		}

		transform.Translate (((direction == 1) ? 1 : -1) * Time.deltaTime * cameraMoveSpeed, 0, 0, Space.World);
	}
}
