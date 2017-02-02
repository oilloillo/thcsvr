--炼狱不死鸟✿藤原妹红
function c21167.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(c21167.xyzfilter),9,2,aux.Stringid(21167,0))
	-- xyzop
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21167,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c21167.xyzcon)
	e1:SetOperation(c21167.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21167,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c21167.discon)
	e2:SetTarget(c21167.distg)
	e2:SetOperation(c21167.disop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21167,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c21167.descost)
	e3:SetTarget(c21167.destg)
	e3:SetOperation(c21167.desop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21167,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCost(c21167.hspcost)
	e4:SetTarget(c21167.hsptg)
	e4:SetOperation(c21167.hspop)
	c:RegisterEffect(e4)
end
function c21167.hofilter(c, tp, xyzc, lv)
	if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
	return c:IsSetCard(0x137) and c:IsFaceup()
end
function c21167.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	return Duel.IsExistingMatchingCard(c21167.hofilter, tp, LOCATION_MZONE, 0, 2, nil, tp, c)
end
function c21167.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local mg = Duel.SelectMatchingCard(tp, c21167.hofilter, tp, LOCATION_MZONE, 0, 2, 2, nil, tp, c)
	if mg:GetCount()<2 then return end
		c:SetMaterial(mg)
		Duel.Overlay(c, mg)
end
function c21167.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c21167.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c21167.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.GetLP(tp)-Duel.GetLP(1-tp)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end
function c21167.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c21167.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c21167.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21167.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c21167.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c21167.filter,tp,LOCATION_DECK,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21167.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c21167.filter,tp,LOCATION_DECK,0,1,1,nil)
	local g=Duel.SelectMatchingCard(tp,c21167.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	dg:Merge(g)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c21167.rfilter(c)
	return (c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsAbleToRemoveAsCost()
end
function c21167.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21167.rfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21167.rfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21167.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21167.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
