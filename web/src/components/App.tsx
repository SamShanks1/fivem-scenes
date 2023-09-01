import React, { useEffect, useState, forwardRef } from "react";
import {
  Box,
  createStyles,
  Stack,
  Center,
  TextInput,
  Select,
  Slider,
  Group,
  Switch,
  Button,
  Text,
  ColorInput,
  Tooltip,
  ActionIcon,
} from "@mantine/core";
import { TextSize, RulerMeasure } from "tabler-icons-react";
import { fetchNui } from "../utils/fetchNui";

interface IFonts {
  label: string;
  value: string;
  group: string;
}

interface ItemProps extends React.ComponentPropsWithoutRef<"div"> {
  image: string;
  label: string;
  description: string;
}

interface IConfig {
  maxDuration: number;
  maxDistance: number;
}

const SelectItem = forwardRef<HTMLDivElement, ItemProps>(
  ({ image, label, description, ...others }: ItemProps, ref) => (
    <div ref={ref} {...others}>
      <Group noWrap>
        <div>
          <Text size="sm">{label}</Text>
          <Text size="xs" opacity={0.65}>
            {description}
          </Text>
        </div>
      </Group>
    </div>
  )
);

const useStyles = createStyles((theme) => ({
  wrapper: {
    position: "absolute",
    top: "15px",
    right: "15px",
    width: 330,
    height: 710,
    backgroundColor: theme.colors.dark[7],
    borderRadius: theme.radius.md,
    color: theme.colors.dark[1],
  },
}));

const BackgroundSprites = [
  { label: "None", value: "none", description: "No Background" },
  { label: "Sleek", value: "TallFive", description: "Tall and sleek. (5px)" },
  { label: "Sleek 2", value: "TallTen", description: "Tall and sleek. (10px)" },
  {
    label: "Sleek 3",
    value: "TallFifteen",
    description: "Tall and sleek. (15px)",
  },
  {
    label: "Simple",
    value: "Background",
    description: "As simple as it gets.",
  },
  { label: "Blood", value: "Blood", description: "Bloody mess." },
  { label: "Blood 2", value: "Blood2", description: "Bloody mess." },
  { label: "Blood 3", value: "Blood3", description: "Bloody mess." },
  { label: "Blood 4", value: "Blood4", description: "Bloody mess." },
  { label: "Blood 5", value: "Blood5", description: "Bloody mess." },
  { label: "Brush", value: "Brush", description: "A simple brush stroke." },
  { label: "Chain", value: "Chain", description: '"Never break the chain"' },
  {
    label: "Metal",
    value: "Metal",
    description: "Not to be confused with rock.",
  },
  {
    label: "Metal 2",
    value: "Metal2",
    description: "Not to be confused with rock.",
  },
  {
    label: "Gradient",
    value: "Gradient1",
    description: "A little bit of gradient in my life.",
  },
  {
    label: "Gradient 2",
    value: "Gradient2",
    description: "A little bit of gradient by my side.",
  },
  {
    label: "Gradient 3",
    value: "Gradient3",
    description: "A little bit of gradient is all i need.",
  },
  {
    label: "Gradient 4",
    value: "Gradient4",
    description: "A little bit of gradient is what i see.",
  },
  { label: "Noise", value: "Noise", description: "Too loud." },
  { label: "Note", value: "Note", description: "Colour white recommended." },
  { label: "Note 2", value: "Note2", description: "Colour white recommended." },
  { label: "Note 3", value: "Note3", description: "Colour white recommended." },
  { label: "Note 4", value: "Note4", description: "Colour white recommended." },
  { label: "Note 5", value: "Note5", description: "Colour white recommended." },
  { label: "Note 6", value: "Note6", description: "Colour white recommended." },
  { label: "Spray", value: "Spray", description: "Just a spray." },
];

const App: React.FC = () => {
  const { classes } = useStyles();
  const [text, setText] = useState("");
  const [font, setFont] = useState<string | null>("0");
  const [colour, setColour] = useState("#ffffff");
  const [fontSize, setFontSize] = useState(0.2);
  const [shadow, setShadow] = useState(false);
  const [outline, setOutline] = useState(false);
  const [background, setBackground] = useState<string | null>("none");
  const [backgroundHeight, setBackgroundHeight] = useState(0.01);
  const [backgroundWidth, setBackgroundWidth] = useState(0.01);
  const [backgroundColour, setBackgroundColour] = useState("#000000");
  const [backgroundAlpha, setBackgroundAlpha] = useState(128);
  const [backgroundX, setBackgroundX] = useState(0);
  const [backgroundY, setBackgroundY] = useState(0.034);
  const [duration, setDuration] = useState(1);
  const [viewDistance, setViewDistance] = useState(5);
  const [maxViewDistance, setMaxViewDistance] = useState(25);
  const [maxDuration, setMaxDuration] =  useState(50);
  // const [showDuration, setShowDuration] = useState(false);

  const [fontOptions, setFontOptions] = useState<IFonts[]>([
    { label: "Chalet Comprimé", value: "4", group: "Normal" },
    { label: "Chalet", value: "0", group: "Normal" },
    { label: "Sign Painter", value: "1", group: "Handwritten" },
    { label: "Pricedown", value: "7", group: "Misc" },
  ]);

  useEffect(() => {
    fetchNui<IFonts[]>("getFonts").then((retData) => {
      setFontOptions(retData);
    });

    fetchNui<IConfig>("getMaxViewDistance").then((retData) => {
      setMaxViewDistance(retData.maxDistance);
      setMaxDuration(retData.maxDuration);
    });
  });

  const resetMenu = () => {
    setText("");
    setFont("0");
    setColour("#ffffff");
    setFontSize(0.2);
    setShadow(false);
    setOutline(false);
    setBackground("none");
    setBackgroundHeight(0.01);
    setBackgroundWidth(0.01);
    setBackgroundColour("#000000");
    setBackgroundAlpha(128);
    setBackgroundX(0);
    setBackgroundY(0.034);
    setDuration(1);
    setViewDistance(5);
  };

  useEffect(() => {
    fetchNui("UpdateScene", {
      text: text,
      font: Number(font),
      colour: colour,
      fontSize: fontSize,
      shadow: shadow,
      outline: outline,
      background: background,
      backgroundHeight: backgroundHeight,
      backgroundWidth: backgroundWidth,
      backgroundColour: backgroundColour,
      backgroundAlpha: backgroundAlpha,
      backgroundX: backgroundX,
      backgroundY: backgroundY,
      duration: duration,
      viewDistance: viewDistance,
      // showDuration: showDuration,
    });
  }, [
    text,
    font,
    colour,
    fontSize,
    shadow,
    outline,
    background,
    backgroundHeight,
    backgroundWidth,
    backgroundColour,
    backgroundAlpha,
    backgroundX,
    backgroundY,
  ]);

  return (
    <Box className={classes.wrapper}>
      <Center>
        <Stack sx={{ width: "90%", paddingTop: 15 }} spacing="xs">
          {/* TEXT INPUT */}
          <TextInput
            placeholder="Scene Text"
            label="Scene Text"
            value={text}
            onChange={(event) => {
              setText(event.currentTarget.value);
            }}
          />

          {/* FONT SELECT */}
          <Select
            placeholder="Font"
            label="Font"
            data={fontOptions}
            value={font}
            onChange={setFont}
          />

          {/* COLOUR SELECT */}
          <ColorInput value={colour} onChange={setColour} label="Text Colour" />

          {/* FONT SIZE */}
          <Group>
            <Tooltip label="Font Size" color="blue" withArrow>
              <ActionIcon>
                <TextSize color={"white"} />
              </ActionIcon>
            </Tooltip>
            <Slider
              sx={{ flexGrow: 1 }}
              min={0.1}
              max={1}
              step={0.1}
              value={fontSize}
              onChange={setFontSize}
            />
          </Group>

          {/* View Distance */}
          <Group>
            <Tooltip label="View Distance" color="blue" withArrow>
              <ActionIcon>
                <RulerMeasure color={"white"} />
              </ActionIcon>
            </Tooltip>
            <Slider
              sx={{ flexGrow: 1 }}
              min={1}
              max={maxViewDistance}
              step={1}
              value={viewDistance}
              onChange={setViewDistance}
            />
          </Group>

          {/* SHADOW AND OUTLINE */}
          <Group spacing="xl">
            <Switch
              label="Shadow"
              checked={shadow}
              onChange={(event) => {
                setShadow(event.currentTarget.checked);
              }}
            />
            <Switch
              label="Outline"
              checked={outline}
              onChange={(event) => {
                setOutline(event.currentTarget.checked);
              }}
            />
          </Group>

          {/* BACKGROUND */}
          <Select
            placeholder="Background"
            label="Background"
            data={BackgroundSprites}
            itemComponent={SelectItem}
            value={background}
            onChange={setBackground}
          />

          {/* BACKGROUND COLOUR */}
          <ColorInput
            value={backgroundColour}
            onChange={setBackgroundColour}
            label="Background Colour"
          />

          {/* BACKGROUND HEIGHT */}
          <Group>
            <Text fz="sm">Background Height</Text>
            <Slider
              sx={{ flexGrow: 1 }}
              min={-0.5}
              step={0.002}
              max={0.5}
              label={null}
              value={backgroundHeight}
              onChange={setBackgroundHeight}
            />
          </Group>

          {/* BACKGROUND WIDTH */}
          <Group>
            <Text fz="sm">Background Width</Text>
            <Slider
              sx={{ flexGrow: 1 }}
              min={-0.5}
              step={0.002}
              max={0.5}
              label={null}
              value={backgroundWidth}
              onChange={setBackgroundWidth}
            />
          </Group>

          {/* BACKGROUND OPACITY */}
          <Group>
            <Text fz="sm">Background Opacity</Text>
            <Slider
              max={255}
              sx={{ flexGrow: 1 }}
              value={backgroundAlpha}
              onChange={setBackgroundAlpha}
            />
          </Group>

          {/* BACKGROUND X */}
          <Group>
            <Text fz="sm">Background X</Text>
            <Slider
              sx={{ flexGrow: 1 }}
              step={0.002}
              min={-0.2}
              max={0.2}
              label={null}
              value={backgroundX}
              onChange={setBackgroundX}
            />
          </Group>

          {/* BACKGROUND Y */}
          <Group>
            <Text fz="sm">Background Y</Text>
            <Slider
              sx={{ flexGrow: 1 }}
              step={0.002}
              min={-0.2}
              max={0.2}
              label={null}
              value={backgroundY}
              onChange={setBackgroundY}
            />
          </Group>

          {/* DURATION */}
          <Group>
            <Text fz="sm">Duration (Hours)</Text>
            <Slider
              sx={{ flexGrow: 1 }}
              step={1}
              min={1}
              max={maxDuration}
              value={duration}
              onChange={setDuration}
            />
          </Group>

          {/* SHOW SCENE DURATION */}
          {/* <Switch
            label="Show Scene Duration"
            checked={showDuration}
            onChange={(event) => {
              setShowDuration(event.currentTarget.checked);
            }}
          />  */}

          <Group>
            <Button
              color="green"
              onClick={() => {
                fetchNui("CreateScene");
                resetMenu();
              }}
            >
              Submit
            </Button>
            <Button onClick={resetMenu}>Reset</Button>
            <Button color="red" onClick={() => fetchNui("hideFrame")}>
              Cancel
            </Button>
          </Group>
        </Stack>
      </Center>
    </Box>
  );
};

export default App;
