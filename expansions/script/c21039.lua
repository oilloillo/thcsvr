 
--绵月依姬
function c21039.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21039.spcon)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--self destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c21039.sdcon)
	c:RegisterEffect(e5)
end

c21039.DescSetName=0x258

function c21039.spfilter(c)
	return (c:IsSetCard(0x256) or c:IsSetCard(0x258)) and c:IsType(TYPE_MONSTER)
end
function c21039.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroupCount(c21039.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	return g>4
end
function c21039.sdfilter(c)
	return c:IsFaceup() and (c:IsCode(21034) or c:IsSetCard(0x254))
end
function c21039.sdcon(e)
	return not Duel.IsExistingMatchingCard(c21039.sdfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end