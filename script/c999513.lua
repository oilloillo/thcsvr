--✿光之三妖精☆
--modded by Karen
local M = c999513
local Mid = 999513
function M.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_FUSION_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(M.fuscon)
	e3:SetOperation(M.fusop)
	c:RegisterEffect(e3)
	-- search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(Mid,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(M.thtg)
	e3:SetOperation(M.thop)
	c:RegisterEffect(e3)
end
M.material={25020,25021,25022}
M.material_count=3
M.hana_mat={Fus.CodeFilter(25020),Fus.CodeFilter(25021),Fus.CodeFilter(25022)}
function M.mtfilter1(c,mg,sg,exg,chkf,ct)
	if sg:IsContains(c) then return false end
	local sg1=sg:Clone()
	sg1:AddCard(c)
	if sg1:GetCount()==3 then
		if sg1:FilterCount(M.chkfilter,nil,exg)>ct then return false end
		if chkf~=PLAYER_NONE and not mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
		return sg1:IsExists(M.fusfilter,1,nil,sg1,25020)
	end
	return mg:IsExists(M.mtfilter1,1,nil,mg,sg1,exg,chkf,ct)
end
function M.fusfilter(c,sg1,code)
	if not c:IsFusionCode(code) then return false end
	if code==25022 then return true end
	local sg2=sg1:Filter(aux.TRUE,c)
	return sg2:IsExists(M.fusfilter,1,nil,sg2,code+1)
end
function M.chkfilter(c,exg)
	return exg:IsContains(c)
end
function M.exfilter(c,fc,mg)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsCanBeFusionMaterial(fc) and not mg:IsContains(c)
end
function M.exfilter2(c,fc,mg)
	return c:IsCanBeFusionMaterial(fc) and not mg:IsContains(c)
end
function M.fuscon(e,g,gc,chkf)
	if g==nil then return false end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local ct=Duel.GetMatchingGroup(M.filter2,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	local exg=Duel.GetMatchingGroup(M.exfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e:GetHandler(),mg)
	local exg2=Duel.GetFusionMaterial(e:GetHandlerPlayer()):Filter(M.exfilter2,nil,e:GetHandler(),mg)
	mg:Merge(exg)
	mg:Merge(exg2)
	return mg:IsExists(M.mtfilter1,1,nil,mg,sg,exg,chkf,ct)
end
function M.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(Card.IsCanBeFusionMaterial,nil,c)
	local ct=Duel.GetMatchingGroup(M.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	local exg=Duel.GetMatchingGroup(M.exfilter,tp,LOCATION_GRAVE,0,nil,c,mg)
	local exg2=Duel.GetFusionMaterial(e:GetHandlerPlayer()):Filter(M.exfilter2,nil,e:GetHandler(),mg)
	mg:Merge(exg)
	mg:Merge(exg2)
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,M.mtfilter1,1,1,nil,mg,sg,exg,chkf,ct)
		sg:Merge(g)
	until sg:GetCount()==3
	local rg1=sg:Filter(M.chkfilter,nil,exg)
	local rg2=sg:Filter(M.chkfilter,nil,exg2)
	for rc in aux.Next(rg1) do
		rc:RegisterFlagEffect(999513,RESET_CHAIN,0,1,1)
	end
	for rc in aux.Next(rg2) do
		rc:RegisterFlagEffect(999513,RESET_CHAIN,0,1,2)
	end
	Duel.SetFusionMaterial(sg)
end
M.OriginalSetMaterial=Card.SetMaterial
function M.SetMaterial(c,g)
	M.OriginalSetMaterial(c,g)
	local rg1=g:Filter(M.rfilter,nil,1)
	if rg1:GetCount()>0 then
		g:Sub(rg1)
		Duel.Remove(rg1,POS_FACEUP,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT)
		for rc in aux.Next(rg1) do
			rc:ResetFlagEffect(999513)
		end
	end
	local rg2=g:Filter(M.rfilter,nil,2)
	if rg2:GetCount()>0 then
		g:Sub(rg2)
		Duel.SendtoGrave(rg2,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT)
		for rc in aux.Next(rg2) do
			rc:ResetFlagEffect(999513)
		end
	end
end
function M.rfilter(c,l)
	return c:GetFlagEffectLabel(999513)==l
end
function M.filter2(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0x999) or c:GetOriginalCode()==22090) and c:IsFaceup()
end
function M.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and (c:IsSetCard(0x999) or c:GetOriginalCode()==22090)
end
function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK+LOCATION_GRAVE)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end
